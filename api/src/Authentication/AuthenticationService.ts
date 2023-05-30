import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { JWT } from '../Shared/Modules/JWT'
import { UserRoleTypeEnum } from '../User/Enums/UserRoleTypeEnum'
import { UserService } from '../User/UserService'
import { AuthenticationRepository } from './AuthenticationRepository'
import { AuthenticationCreateDto } from './Dto/AuthenticationCreateDto'
import { AuthenticationTokenDto } from './Dto/AuthenticationTokenDto'
import { AuthenticationStatusEnum } from './Enums/AuthenticationStatusEnum'
import { Authentication } from './Models/Authentication'

export class AuthenticationService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly authenticationRepository: AuthenticationRepository,
    private readonly userService: UserService,
    private readonly jwt: JWT
  ) {
    super(dataSource)
  }

  async create(data: AuthenticationCreateDto) {
    const user = await this.userService.findOneByAuthData(data)

    const userOrganization = user
      .getAllOrganizations()
      .filter(usrOrg =>
        data.isCustomer
          ? usrOrg.getRoleType() === UserRoleTypeEnum.CUSTOMER
          : usrOrg.getRoleType() !== UserRoleTypeEnum.CUSTOMER
      )?.[0]

    const jwtTokenData: AuthenticationTokenDto = {
      user: {
        id: user.getId(),
        name: user.getName(),
        email: user.getEmail(),
        roleType: userOrganization.getRoleType()
      },
      organization: userOrganization
        ? {
            id: userOrganization.getOrganization().getId()
          }
        : null
    }

    const token = this.jwt.sign(jwtTokenData)

    return await this.authenticationRepository.create(
      new Authentication(token, data.device, AuthenticationStatusEnum.ENABLED, userOrganization)
    )
  }
}
