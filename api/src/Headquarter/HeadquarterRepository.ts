import { SelectQueryBuilder } from 'typeorm'
import { OrganizationDao } from '../Organization/Models/OrganizationDao'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Headquarter } from './Models/Headquarter'
import { HeadquarterDao } from './Models/HeadquarterDao'

export class HeadquarterRepository extends TypeOrmMysqlRepositoryContract<
  Headquarter,
  HeadquarterDao
> {
  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<HeadquarterDao>
  ): SelectQueryBuilder<HeadquarterDao> {
    return query.leftJoinAndSelect('HeadquarterDao.locations', 'locations')
  }

  protected customToFindAll(
    query: SelectQueryBuilder<HeadquarterDao>,
    filter?: FilterDefault
  ): SelectQueryBuilder<HeadquarterDao> {
    return query.leftJoinAndSelect('HeadquarterDao.locations', 'locations')
  }

  getRepository() {
    return this.getManager().getRepository(HeadquarterDao)
  }
}
