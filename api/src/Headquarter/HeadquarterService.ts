import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { LocationRepository } from '../Location/LocationRepository'
import { Organization } from '../Organization/Models/Organization'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'
import { ErrorReason } from '../Shared/Models/Interfaces/ErrorReason'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { HeadquarterCreateDto } from './Dto/HeadquarterCreateDto'
import { HeadquarterUpdateLocationDto } from './Dto/HeadquarterUpdateLocationDto'
import { HeadquarterRepository } from './HeadquarterRepository'
import { HeadquarterValidator } from './HeadquarterValidator'
import { Headquarter } from './Models/Headquarter'

@ServiceDecorator
export class HeadquarterService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: HeadquarterRepository,
    private readonly validator: HeadquarterValidator,
    private readonly locationRepository: LocationRepository
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

  async updateLocations(id: string, data: HeadquarterUpdateLocationDto[]): Promise<Headquarter> {
    await this.validator.validateUpdateLocationsPayload(data)

    const headquarter = await this.getById(id)

    const errorReasons: ErrorReason[] = []

    await Promise.all(
      data.map(async ({ id }, index) => {
        const location = await this.locationRepository.findOneByPrimaryColumn(id)

        if (!location) {
          errorReasons.push({
            id: `[].${index}.id.${id}`,
            message: `Location ${id} not found`
          })
          return
        }

        headquarter.addLocation(location)
      })
    )

    if (errorReasons.length) {
      throw new InvalidDataException('Invalid', errorReasons)
    }

    return this.repository.save(headquarter)
  }
}
