import { DataSource, EntityManager } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Location } from '../Location/Models/Location'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { OrganizationCreateDto } from './Dto/OrganizationCreateDto'
import { Organization } from './Models/Organization'
import { OrganizationRepository } from './OrganizationRepository'
import { OrganizationValidator } from './OrganizationValidator'

@ServiceDecorator
export class OrganizationService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: OrganizationRepository,
    private readonly validator: OrganizationValidator
  ) {
    super(dataSource)
  }

  public async create(data: OrganizationCreateDto): Promise<Organization> {
    await this.validator.organizationCreatePayloadValidate(data)

    return this.repository.save(
      new Organization(
        data.name,
        data.document.type,
        data.document.number,
        data.document.name,
        data.email,
        data.phone
      )
    )
  }

  public async getLocations(id: string): Promise<Location[]> {
    const locations = []

    const organization = await this.repository.findOneByPrimaryColumn(id)

    organization.getHeadquarters().forEach(headquarter => {
      headquarter.getLocations()?.forEach(location => {
        locations.push(location)
      })
    })

    return locations
  }

  public async findOneByDocumentNumber(documentNumber: string): Promise<Organization> {
    return this.repository.findOneByDocumentNumber(documentNumber)
  }

  public setManager(manager: EntityManager) {
    this.repository.setManager(manager)
    return this
  }
}
