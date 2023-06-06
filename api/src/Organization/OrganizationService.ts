import { DataSource, EntityManager } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Service } from '../Shared/Utils/DecoratorUtils'
import { OrganizationCreateDto } from './Dto/OrganizationCreateDto'
import { Organization } from './Models/Organization'
import { OrganizationRepository } from './OrganizationRepository'
import { OrganizationValidator } from './OrganizationValidator'

@Service
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

  public async findOneByDocumentNumber(documentNumber: string): Promise<Organization> {
    return this.repository.findOneByDocumentNumber(documentNumber)
  }

  public setManager(manager: EntityManager) {
    this.repository.setManager(manager)
    return this
  }
}
