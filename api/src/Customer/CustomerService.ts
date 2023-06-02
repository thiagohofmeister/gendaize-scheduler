import { DataSource } from 'typeorm'
import { AuthenticationCreateDto } from '../Authentication/Dto/AuthenticationCreateDto'
import { BaseService } from '../Base/BaseService'
import { UnauthorizedException } from '../Shared/Models/Exceptions/UnauthorizedException'
import { CustomerRepository } from './CustomerRepository'

export class CustomerService extends BaseService {
  constructor(dataSource: DataSource, private readonly repository: CustomerRepository) {
    super(dataSource)
  }

  async findOneByAuthData(data: AuthenticationCreateDto) {
    const customer = await this.repository.findOneByAuthData(
      data.login.toLowerCase(),
      data.password
    )

    if (customer) return customer

    throw new UnauthorizedException()
  }
}
