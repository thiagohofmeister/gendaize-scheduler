import { SelectQueryBuilder } from 'typeorm'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Location } from './Models/Location'
import { LocationDao } from './Models/LocationDao'
import { OrganizationDao } from '../Organization/Models/OrganizationDao'

export class LocationRepository extends TypeOrmMysqlRepositoryContract<Location, LocationDao> {
  protected customToFindAll(
    query: SelectQueryBuilder<LocationDao>,
    filter?: FilterDefault
  ): SelectQueryBuilder<LocationDao> {
    return query.orderBy('LocationDao.state').orderBy('LocationDao.city')
  }

  getRepository() {
    return this.getManager().getRepository(LocationDao)
  }
}
