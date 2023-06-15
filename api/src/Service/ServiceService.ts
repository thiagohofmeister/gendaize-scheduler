import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Organization } from '../Organization/Models/Organization'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'
import { ErrorReason } from '../Shared/Models/Interfaces/ErrorReason'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { TaxService } from '../Tax/TaxService'
import { UserService } from '../User/UserService'
import { ServiceCreateDto } from './Dto/ServiceCreateDto'
import { ServiceUpdateTaxDto } from './Dto/ServiceUpdateTaxDto'
import { ServiceUpdateUserDto } from './Dto/ServiceUpdateUserDto'
import { Service } from './Models/Service'
import { ServiceRepository } from './ServiceRepository'
import { ServiceValidator } from './ServiceValidator'

@ServiceDecorator
export class ServiceService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: ServiceRepository,
    private readonly validator: ServiceValidator,
    private readonly userService: UserService,
    private readonly taxService: TaxService
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
      data.duration,
      organization
    )

    if (data.users) {
      await this.fillUsers(service, data.users)
    }

    if (data.taxes) {
      await this.fillTaxes(service, data.taxes)
    }

    return this.repository.save(service)
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Service>> {
    return this.repository.findAll(filter, false, true)
  }

  async getById(id: string): Promise<Service> {
    return this.repository.findOneByPrimaryColumn(id)
  }

  async updateUsers(id: string, data: ServiceUpdateUserDto[]): Promise<Service> {
    await this.validator.validateUpdateUsersPayload(data)

    const service = await this.getById(id)

    await this.fillUsers(service, data)

    return this.repository.save(service)
  }

  async updateTaxes(id: string, data: ServiceUpdateTaxDto[]): Promise<Service> {
    await this.validator.validateUpdateUsersPayload(data)

    const service = await this.getById(id)

    await this.fillTaxes(service, data)

    return this.repository.save(service)
  }

  private async fillUsers(service: Service, data: ServiceUpdateUserDto[]) {
    const errorReasons: ErrorReason[] = []

    service.removeUsers([])

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
  }

  private async fillTaxes(service: Service, data: ServiceUpdateTaxDto[]) {
    const errorReasons: ErrorReason[] = []

    service.removeTaxes([])

    await Promise.all(
      data.map(async ({ id }, index) => {
        const tax = await this.taxService.getById(id)

        if (!tax) {
          errorReasons.push({
            id: `[].${index}.id.${id}`,
            message: `Tax ${id} not found`
          })
          return
        }

        service.addTax(tax)
      })
    )

    if (errorReasons.length) {
      throw new InvalidDataException('Invalid', errorReasons)
    }
  }
}
