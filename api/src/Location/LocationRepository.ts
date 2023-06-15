import { SelectQueryBuilder } from 'typeorm'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Location } from './Models/Location'
import { LocationDao } from './Models/LocationDao'

export class LocationRepository extends TypeOrmMysqlRepositoryContract<Location, LocationDao> {
  protected customToFindAll(
    query: SelectQueryBuilder<LocationDao>,
    filter?: FilterDefault
  ): SelectQueryBuilder<LocationDao> {
    if (filter.query) {
      query.where(
        "LocationDao.state ilike :search OR LocationDao.city ilike :search OR concat(LocationDao.city, ' ', LocationDao.state) ilike :search OR concat(LocationDao.state, ' ', LocationDao.city) ilike :search",
        {
          search: `%${filter.query}%`
        }
      )
    }

    return query.orderBy('LocationDao.state').orderBy('LocationDao.city')
  }

  getRepository() {
    return this.getManager().getRepository(LocationDao)
  }
}
