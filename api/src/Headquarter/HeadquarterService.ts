import { DataSource, EntityManager } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { LocationRepository } from '../Location/LocationRepository'
import { Organization } from '../Organization/Models/Organization'
import { DataNotFoundException } from '../Shared/Models/Exceptions/DataNotFoundException'
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
    return this.transactionalFn(async manager => {
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

      if (data.locations) {
        await this.fillLocations(manager, headquarter, data.locations)
      }

      return this.repository.setManager(manager).save(headquarter)
    })
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Headquarter>> {
    return this.repository.findAll(filter, false, true)
  }

  async getOneById(id: string): Promise<Headquarter> {
    const headquarter = this.repository.findOneByPrimaryColumn(id)

    if (headquarter) return headquarter

    throw new DataNotFoundException()
  }

  async updateLocations(id: string, data: HeadquarterUpdateLocationDto[]): Promise<Headquarter> {
    return this.transactionalFn(async manager => {
      await this.validator.validateUpdateLocationsPayload(data)

      const headquarter = await this.setManager(manager).getOneById(id)

      if (!headquarter) {
        throw new DataNotFoundException()
      }

      const errorReasons: ErrorReason[] = []

      headquarter.removeLocations(data.map(location => location.id))

      await Promise.all(
        data.map(async ({ id }, index) => {
          const location = await this.locationRepository
            .setManager(manager)
            .findOneByPrimaryColumn(id)

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

      return this.repository.setManager(manager).save(headquarter)
    })
  }

  private async fillLocations(
    manager: EntityManager,
    headquarter: Headquarter,
    data: HeadquarterUpdateLocationDto[]
  ) {
    const errorReasons: ErrorReason[] = []

    headquarter.removeLocations(data.map(location => location.id))

    await Promise.all(
      data.map(async ({ id }, index) => {
        const location = await this.locationRepository
          .setManager(manager)
          .findOneByPrimaryColumn(id)

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
  }

  setManager(manager: EntityManager) {
    this.repository.setManager(manager)
    return this
  }
}
