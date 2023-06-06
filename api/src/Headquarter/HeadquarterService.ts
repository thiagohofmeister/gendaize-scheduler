import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Organization } from '../Organization/Models/Organization'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { Service } from '../Shared/Utils/DecoratorUtils'
import { HeadquarterCreateDto } from './Dto/HeadquarterCreateDto'
import { HeadquarterRepository } from './HeadquarterRepository'
import { HeadquarterValidator } from './HeadquarterValidator'
import { Headquarter } from './Models/Headquarter'

@Service
export class HeadquarterService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: HeadquarterRepository,
    private readonly validator: HeadquarterValidator
  ) {
    super(dataSource)
  }

  async create(organization: Organization, data: HeadquarterCreateDto): Promise<Headquarter> {
    await this.validator.validateCreatePayload(data)

    const headquarter = new Headquarter(
      data.name,
      data.address.state,
      data.address.city,
      data.address.district,
      data.address.street,
      data.address.number,
      data.address.complement,
      data.address.zipCode,
      data.schedules,
      organization
    )

    return this.repository.create(headquarter)
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Headquarter>> {
    return this.repository.findAll(filter)
  }

  async getById(id: string): Promise<Headquarter> {
    return this.repository.findOneByPrimaryColumn(id)
  }
}
