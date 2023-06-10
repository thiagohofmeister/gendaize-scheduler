import { SelectQueryBuilder } from 'typeorm'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Organization } from './Models/Organization'
import { OrganizationDao } from './Models/OrganizationDao'

export class OrganizationRepository extends TypeOrmMysqlRepositoryContract<
  Organization,
  OrganizationDao
> {
  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<OrganizationDao>
  ): SelectQueryBuilder<OrganizationDao> {
    return query
      .leftJoinAndSelect('OrganizationDao.headquarters', 'headquarters')
      .leftJoinAndSelect('headquarters.locations', 'locations')
      .orderBy('locations.state')
      .orderBy('locations.city')
  }

  async findOneByDocumentNumber(documentNumber: string): Promise<Organization> {
    return this.getOne({ where: { documentNumber } })
  }

  getRepository() {
    return this.getManager().getRepository(OrganizationDao)
  }
}
