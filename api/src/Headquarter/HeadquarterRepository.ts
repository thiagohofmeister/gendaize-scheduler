import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Headquarter } from './Models/Headquarter'
import { HeadquarterDao } from './Models/HeadquarterDao'

export class HeadquarterRepository extends TypeOrmMysqlRepositoryContract<
  Headquarter,
  HeadquarterDao
> {
  getRepository() {
    return this.getManager().getRepository(HeadquarterDao)
  }
}
