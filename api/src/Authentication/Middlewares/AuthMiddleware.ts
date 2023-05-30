import { NextFunction, Response } from 'express'
import * as jwt from 'jsonwebtoken'

import { Postgres } from '../../Database/Postgres'
import { EndpointPermissionsService } from '../../EndpointPermissions/EndpointPermissionsService'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { CoreRequest } from '../../Shared/Models/Request/CoreRequest'
import { AuthenticationTokenDto } from '../../User/Dto/AuthenticationTokenDto'
import { UserRoleTypeEnum } from '../../User/Enums/UserRoleTypeEnum'
import { AuthenticationDao } from '../Models/AuthenticationDao'

export class AuthMiddleware {
  public constructor() {
    this.forAll = this.forAll.bind(this)
    this.isPublicRequest = this.isPublicRequest.bind(this)
    this.isGuestRequest = this.isGuestRequest.bind(this)
    this.formatRequest = this.formatRequest.bind(this)
    this.validateRoleAndPermissions = this.validateRoleAndPermissions.bind(this)
    this.decodeToken = this.decodeToken.bind(this)
  }

  public async forAll(req: CoreRequest, res: Response, next: NextFunction): Promise<void> {
    let userPermissions = []

    if (this.isPublicRequest(req)) {
      await this.formatRequest(req, UserRoleTypeEnum.PUBLIC)
    } else if (this.isGuestRequest(req)) {
      await this.formatRequest(req, UserRoleTypeEnum.GUEST)
    } else {
      const [tokenType, token] = req.header('authorization').split(' ')

      const decodedToken = this.decodeToken(token)

      if (tokenType !== 'Bearer' || !decodedToken) {
        res.status(401).send({
          code: `401.unauthorizedException`,
          message: 'Unauthorized.'
        })
        return
      }

      await new Postgres().createDataSource()
      const postgres = Postgres.getDataSource()

      const authentication = await postgres.getRepository(AuthenticationDao).findOne({
        where: {
          userOrganization: {
            user: { id: decodedToken.user.id },
            organization: { id: decodedToken.organization.id }
          },
          token: token
        }
      })

      if (!authentication) {
        res.status(401).send({
          code: `401.unauthorizedException`,
          message: 'Unauthorized.'
        })
        return
      }

      await this.formatRequest(req, decodedToken.user.roleType, decodedToken)
    }

    const roleType = req.context.user.roleType as UserRoleTypeEnum

    if (!(await this.validateRoleAndPermissions(req, roleType))) {
      res.status(401).send({
        code: `401.unauthorizedException`,
        message: 'Unauthorized.'
      })
      return
    }

    next()
  }

  private isPublicRequest(req: CoreRequest) {
    return !req.header('x-organization-id') && !req.header('authorization')
  }

  private isGuestRequest(req: CoreRequest) {
    return !!req.header('x-organization-id')
  }

  private async formatRequest(
    req: CoreRequest,
    roleType: UserRoleTypeEnum,
    token?: AuthenticationTokenDto
  ) {
    if (roleType === UserRoleTypeEnum.GUEST) {
      req.context = {
        organizationId: req.header('x-organization-id'),
        user: {
          id: 'guest',
          email: 'guest@platform.com',
          roleType: UserRoleTypeEnum.GUEST
        }
      }
    } else if (roleType !== UserRoleTypeEnum.PUBLIC) {
      delete req.headers['authorization']

      req.context = {
        organizationId: token.organization.id,
        user: {
          id: token.user.id,
          email: token.user.email,
          roleType: token.user.roleType
        }
      }
    } else {
      req.context = {
        user: {
          roleType: UserRoleTypeEnum.PUBLIC
        }
      }
    }

    if (!!req.context.organizationId) {
      await new Postgres().createDataSource()
      const postgres = Postgres.getDataSource()

      const organization = await postgres.getRepository(OrganizationDao).findOne({
        where: {
          id: req.context.organizationId
        }
      })

      if (!!organization) {
        req.context.organization = organization.toDomain()
      }
    }
  }

  private async validateRoleAndPermissions(req: CoreRequest, roleType: UserRoleTypeEnum) {
    const servicePermissions = await new EndpointPermissionsService().get()
    const permissions =
      servicePermissions.find(sp => sp.getRoleType() === roleType)?.getPermissions() || []

    if (!permissions.length) {
      return false
    }

    let urlAccessedAttrs = req.url.split('/').filter(u => !!u)

    for (const permission of permissions) {
      const endpointAttrs = permission.endpoint.split('/').filter(e => !!e)

      if (endpointAttrs.length !== urlAccessedAttrs.length && !endpointAttrs.includes('*')) {
        continue
      }

      let continue2 = false

      for (const i in endpointAttrs) {
        const endpoint = endpointAttrs[i]
        const accessed = urlAccessedAttrs[i]

        if (endpoint === accessed || endpoint[0] === '$' || endpoint[0] === '*') {
          continue
        }

        continue2 = true
        break
      }

      if (
        continue2 ||
        (!permission.methods.includes(req.method) && !permission.methods.includes('*'))
      ) {
        continue
      }

      return true
    }

    return false
  }

  private decodeToken(token: string): AuthenticationTokenDto {
    try {
      const decodedToken = jwt.verify(token, process.env.JWT_KEY, { algorithms: ['HS256'] })
      delete decodedToken['iat']
      return decodedToken as AuthenticationTokenDto
    } catch {
      return null
    }
  }
}
