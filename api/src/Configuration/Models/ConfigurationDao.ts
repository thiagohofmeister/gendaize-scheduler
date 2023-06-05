import { Column, Entity, JoinColumn, OneToMany, PrimaryColumn } from 'typeorm'
import { OrganizationConfigurationDao } from '../../OrganizationConfiguration/Models/OrganizationConfigurationDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { ConfigurationTypeEnum } from '../Enums/ConfigurationTypeEnum'
import { Configuration } from './Configuration'

@Entity('configuration')
export class ConfigurationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  identifier: string

  @Column()
  label: string

  @Column({
    type: 'enum',
    enum: ConfigurationTypeEnum
  })
  type: ConfigurationTypeEnum

  @Column({
    name: 'type_values',
    type: 'json'
  })
  typeValues: string[]

  @OneToMany(
    () => OrganizationConfigurationDao,
    OrganizationConfiguration => OrganizationConfiguration.configuration
  )
  @JoinColumn({
    name: 'configuration_id'
  })
  organizationConfigurations: OrganizationConfigurationDao[]

  constructor(
    id: string,
    identifier: string,
    label: string,
    type: ConfigurationTypeEnum,
    typeValues: string[]
  ) {
    this.id = id
    this.identifier = identifier
    this.label = label
    this.type = type
    this.typeValues = typeValues
  }

  toDomain() {
    const domain = new Configuration(
      this.identifier,
      this.label,
      this.type,
      this.typeValues,
      this.id
    )

    if (this.organizationConfigurations) {
      this.organizationConfigurations.map(orgConf =>
        domain.addOrganizationConfiguration(orgConf.toDomain())
      )
    }

    return domain
  }
}
