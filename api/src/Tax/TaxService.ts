import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { Organization } from '../Organization/Models/Organization'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { TaxCreateDto } from './Dto/TaxCreateDto'
import { Tax } from './Models/Tax'
import { TaxRepository } from './TaxRepository'
import { TaxValidator } from './TaxValidator'

@ServiceDecorator
export class TaxService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: TaxRepository,
    private readonly validator: TaxValidator
  ) {
    super(dataSource)
  }

  async getById(id: string) {
    return this.repository.findOneByPrimaryColumn(id)
  }

  async create(organization: Organization, data: TaxCreateDto) {
    await this.validator.validateCreatePayload(data)

    const tax = new Tax(
      data.label,
      data.type,
      data.valueType,
      data.value,
      data.valueDetails,
      organization
    )

    return this.repository.save(tax)
  }
}
