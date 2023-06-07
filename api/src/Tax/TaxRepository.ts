import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Tax } from './Models/Tax'
import { TaxDao } from './Models/TaxDao'

export class TaxRepository extends TypeOrmMysqlRepositoryContract<Tax, TaxDao> {
  getRepository() {
    return this.getManager().getRepository(TaxDao)
  }
}
