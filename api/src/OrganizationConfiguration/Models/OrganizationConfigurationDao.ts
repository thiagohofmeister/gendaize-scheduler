import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm'
import { ConfigurationDao } from '../../Configuration/Models/ConfigurationDao'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { OrganizationConfiguration } from './OrganizationConfiguration'

@Entity('user_organization')
export class OrganizationConfigurationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @ManyToOne(() => ConfigurationDao, configuration => configuration.organizationConfigurations)
  @JoinColumn({
    name: 'user_id'
  })
  configuration: ConfigurationDao

  @ManyToOne(() => OrganizationDao, organization => organization.organizationConfigurations)
  @JoinColumn({
    name: 'organization_id'
  })
  organization: OrganizationDao

  @Column()
  value: string

  constructor(
    id: string,
    value: string,
    configuration: ConfigurationDao,
    organization: OrganizationDao
  ) {
    this.id = id
    this.value = value
    this.configuration = configuration
    this.organization = organization
  }

  toDomain() {
    return new OrganizationConfiguration(
      this.value,
      this.configuration?.toDomain(),
      this.organization?.toDomain(),
      this.id
    )
  }
}
