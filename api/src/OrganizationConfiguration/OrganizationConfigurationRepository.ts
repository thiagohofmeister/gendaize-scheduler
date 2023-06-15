import { SelectQueryBuilder } from 'typeorm'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { OrganizationConfiguration } from './Models/OrganizationConfiguration'
import { OrganizationConfigurationDao } from './Models/OrganizationConfigurationDao'
import { OrganizationDao } from '../Organization/Models/OrganizationDao'

export class OrganizationConfigurationRepository extends TypeOrmMysqlRepositoryContract<
  OrganizationConfiguration,
  OrganizationConfigurationDao
> {
  async findByUserIdAndOrganizationId(
    configurationId: string,
    organizationId: string
  ): Promise<OrganizationConfiguration[]> {
    return (
      await this.getMany({
        where: {
          configuration: { id: configurationId },
          organization: { id: organizationId }
        }
      })
    ).items
  }

  getRepository() {
    return this.getManager().getRepository(OrganizationConfigurationDao)
  }
}
