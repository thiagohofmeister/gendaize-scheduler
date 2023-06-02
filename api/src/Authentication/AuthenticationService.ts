import { DataSource, EntityManager } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { CustomerService } from '../Customer/CustomerService'
import { Customer } from '../Customer/Models/Customer'
import { JWT } from '../Shared/Modules/JWT'
import { User } from '../User/Models/User'
import { UserService } from '../User/UserService'
import { UserOrganization } from '../UserOrganization/Models/UserOrganization'
import { AuthenticationRepository } from './AuthenticationRepository'
import { AuthenticationCreateDto } from './Dto/AuthenticationCreateDto'
import { AuthenticationTokenDto } from './Dto/AuthenticationTokenDto'
import { AuthenticationStatusEnum } from './Enums/AuthenticationStatusEnum'
import { Authentication } from './Models/Authentication'

export class AuthenticationService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: AuthenticationRepository,
    private readonly userService: UserService,
    private readonly customerService: CustomerService,
    private readonly jwt: JWT
  ) {
    super(dataSource)
  }

  async logout(id: string) {
    await this.repository.delete(id)
  }

  async authenticate(data: AuthenticationCreateDto) {
    if (data.isCustomer) {
      const customer = await this.customerService.findOneByAuthData(data)
      return this.authenticateCustomer(customer, data.device)
    }

    const user = await this.userService.findOneByAuthData(data)

    return await this.authenticateUser(user, data.device)
  }

  public async authenticateCustomer(customer: Customer, device: string): Promise<Authentication> {
    return this.repository.create(
      new Authentication(
        this.generateTokenToCustomer(customer),
        device,
        AuthenticationStatusEnum.ENABLED,
        null,
        customer
      )
    )
  }

  public async authenticateUser(user: User, device: string): Promise<Authentication> {
    const userOrganization = user.getAllOrganizations()?.[0]

    return this.repository.create(
      new Authentication(
        this.generateTokenToUser(user, userOrganization),
        device,
        AuthenticationStatusEnum.ENABLED,
        userOrganization
      )
    )
  }

  private generateTokenToUser(user: User, userOrganization: UserOrganization) {
    const jwtTokenData: AuthenticationTokenDto = {
      user: {
        id: user.getId(),
        name: user.getName(),
        email: user.getEmail(),
        roleType: userOrganization.getRoleType()
      },
      organization: {
        id: userOrganization.getOrganization().getId()
      }
    }

    return this.jwt.sign(jwtTokenData)
  }

  private generateTokenToCustomer(customer: Customer) {
    const jwtTokenData: AuthenticationTokenDto = {
      customer: {
        id: customer.getId(),
        name: customer.getName(),
        email: customer.getEmail(),
        phone: customer.getPhone()
      },
      organization: {
        id: customer.getOrganization().getId()
      }
    }

    return this.jwt.sign(jwtTokenData)
  }

  public setManager(manager: EntityManager) {
    this.repository.setManager(manager)
    return this
  }
}
