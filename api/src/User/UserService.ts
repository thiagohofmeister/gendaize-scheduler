import { DataSource, EntityManager } from 'typeorm'
import { AuthenticationCreateDto } from '../Authentication/Dto/AuthenticationCreateDto'
import { BaseService } from '../Base/BaseService'
import { Organization } from '../Organization/Models/Organization'
import { UnauthorizedException } from '../Shared/Models/Exceptions/UnauthorizedException'
import { UserOrganizationStatusEnum } from '../UserOrganization/Enums/UserOrganizationStatusEnum'
import { UserOrganization } from '../UserOrganization/Models/UserOrganization'
import { UserCreateDto } from './Dto/UserCreateDto'
import { UserRoleTypeEnum } from './Enums/UserRoleTypeEnum'
import { UserDataNotFound } from './Exceptions/UserDataNotFound'
import { User } from './Models/User'
import { UserRepository } from './UserRepository'
import { UserValidator } from './UserValidator'

export class UserService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: UserRepository,
    private readonly validator: UserValidator
  ) {
    super(dataSource)
  }

  async getById(id: string) {
    const result = await this.repository.findOneByPrimaryColumn(id)

    if (!result) throw new UserDataNotFound()

    return result
  }

  async findOneByAuthData(data: AuthenticationCreateDto) {
    const user = await this.repository.findOneByAuthData(data.login.toLowerCase(), data.password)

    if (user) return user

    throw new UnauthorizedException()
  }

  public async create(organization: Organization, data: UserCreateDto): Promise<User> {
    await this.validator.userCreatePayloadValidate(data)

    const user = new User(data.name, data.documentNumber, data.email.toLowerCase(), data.password)

    user.addOrganization(
      new UserOrganization(
        UserRoleTypeEnum.MANAGER,
        UserOrganizationStatusEnum.ACTIVE,
        null,
        organization
      )
    )

    await this.repository.save(user)

    return user
  }

  public async findOneByDocumentNumber(documentNumber: string): Promise<User> {
    return this.repository.findOneByDocumentNumber(documentNumber)
  }

  public setManager(manager: EntityManager) {
    this.repository.setManager(manager)
    return this
  }
}
