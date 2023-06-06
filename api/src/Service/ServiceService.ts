import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Organization } from '../Organization/Models/Organization'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { ServiceCreateDto } from './Dto/ServiceCreateDto'
import { Service } from './Models/Service'
import { ServiceRepository } from './ServiceRepository'
import { ServiceValidator } from './ServiceValidator'
import { ServiceUpdateUserDto } from './Dto/ServiceUpdateUserDto'
import { ErrorReason } from '../Shared/Models/Interfaces/ErrorReason'
import { UserService } from '../User/UserService'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'

@ServiceDecorator
export class ServiceService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: ServiceRepository,
    private readonly validator: ServiceValidator,
    private readonly userService: UserService
  ) {
    super(dataSource)
  }

  async create(organization: Organization, data: ServiceCreateDto): Promise<Service> {
    await this.validator.validateCreatePayload(data)

    const service = new Service(
      data.name,
      data.price,
      data.type,
      data.sameTimeQuantity,
      organization
    )

    return this.repository.save(service)
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Service>> {
    return this.repository.findAll(filter)
  }

  async getById(id: string): Promise<Service> {
    return this.repository.findOneByPrimaryColumn(id)
  }

  async updateUsers(id: string, data: ServiceUpdateUserDto[]): Promise<Service> {
    await this.validator.validateUpdateUsersPayload(data)

    const service = await this.getById(id)

    const errorReasons: ErrorReason[] = []

    await Promise.all(
      data.map(async ({ id }, index) => {
        const user = await this.userService.getById(id)

        if (!user) {
          errorReasons.push({
            id: `[].${index}.id.${id}`,
            message: `User ${id} not found`
          })
          return
        }

        service.addUser(user)
      })
    )

    if (errorReasons.length) {
      throw new InvalidDataException('Invalid', errorReasons)
    }

    return this.repository.save(service)
  }
}
