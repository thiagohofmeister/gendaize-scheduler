import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { UnauthorizedException } from '../Shared/Models/Exceptions/UnauthorizedException'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class AuthenticationController extends BaseController {
  constructor() {
    super()
    this.post = this.post.bind(this)
    this.logout = this.logout.bind(this)
  }

  async logout(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req))
        .buildAuthenticationService()
        .logout(req.context?.authenticationId),
      ResponseTypeEnum.NO_CONTENT
    )
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    const [tokenType, tokenBase64] = req.header('authorization')?.split(' ') || []

    if (tokenType !== 'Basic') {
      next(new UnauthorizedException())
    }

    const [login, password] = Buffer.from(tokenBase64, 'base64').toString().split(':')

    if (!login || !password) {
      next(new UnauthorizedException())
    }

    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req)).buildAuthenticationService().authenticate({
        device: req.header('User-Agent'),
        isCustomer: !!req.header('x-customer-app'),
        login,
        password
      }),
      ResponseTypeEnum.CREATED
    )
  }
}
