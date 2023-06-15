import { SelectQueryBuilder } from 'typeorm'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Service } from './Models/Service'
import { ServiceDao } from './Models/ServiceDao'
import { OrganizationDao } from '../Organization/Models/OrganizationDao'

export class ServiceRepository extends TypeOrmMysqlRepositoryContract<Service, ServiceDao> {
  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<ServiceDao>
  ): SelectQueryBuilder<ServiceDao> {
    return query
      .leftJoinAndSelect('ServiceDao.users', 'users')
      .leftJoinAndSelect('ServiceDao.taxes', 'taxes')
  }

  getRepository() {
    return this.getManager().getRepository(ServiceDao)
  }
}
