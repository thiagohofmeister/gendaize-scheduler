import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Location } from './Models/Location'
import { LocationDao } from './Models/LocationDao'

export class LocationRepository extends TypeOrmMysqlRepositoryContract<Location, LocationDao> {
  getRepository() {
    return this.getManager().getRepository(LocationDao)
  }
}
