import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { HeadquarterRepository } from './HeadquarterRepository'
import { Headquarter } from './Models/Headquarter'

export class HeadquarterService extends BaseService {
  constructor(dataSource: DataSource, private repository: HeadquarterRepository) {
    super(dataSource)
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Headquarter>> {
    return this.repository.findAll(filter)
  }

  async getById(id: string): Promise<Headquarter> {
    return this.repository.findOneByPrimaryColumn(id)
  }
}
