import { randomUUID } from 'crypto'
import { OrganizationConfiguration } from '../../OrganizationConfiguration/Models/OrganizationConfiguration'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { ConfigurationTypeEnum } from '../Enums/ConfigurationTypeEnum'
import { ConfigurationDao } from './ConfigurationDao'

export class Configuration implements DomainModel, ResponseModel {
  private organizationConfigurations: OrganizationConfiguration[]

  constructor(
    private identifier: string,
    private label: string,
    private type: ConfigurationTypeEnum,
    private typeValues: string[],
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getTypeValues(): string[] {
    return this.typeValues
  }

  public getType(): ConfigurationTypeEnum {
    return this.type
  }

  public getLabel(): string {
    return this.label
  }

  public getIdentifier(): string {
    return this.identifier
  }

  public getId(): string {
    return this.id
  }

  public getOrganizationConfigurations(): OrganizationConfiguration[] {
    return this.organizationConfigurations
  }

  public removeOrganizationConfiguration(idsToKeep: string[]): this {
    if (!this.organizationConfigurations) this.organizationConfigurations = []

    this.organizationConfigurations = this.organizationConfigurations.filter(
      organizationConfiguration => idsToKeep.includes(organizationConfiguration.getId())
    )

    return this
  }

  public addOrganizationConfiguration(organizationConfiguration: OrganizationConfiguration): this {
    if (!this.organizationConfigurations) this.organizationConfigurations = []

    this.organizationConfigurations.push(organizationConfiguration)

    return this
  }

  toView() {
    return {
      id: this.getId(),
      identifier: this.getIdentifier(),
      label: this.getLabel(),
      type: this.getType(),
      typeValues: this.getTypeValues(),
      organizationConfigurations: this.getOrganizationConfigurations()?.map(orgConf =>
        orgConf.toView()
      )
    }
  }

  toDao() {
    const entity = new ConfigurationDao(
      this.getId(),
      this.getIdentifier(),
      this.getLabel(),
      this.getType(),
      this.getTypeValues()
    )

    if (this.getOrganizationConfigurations()) {
      entity.organizationConfigurations = this.getOrganizationConfigurations().map(orgConf =>
        orgConf.toDao()
      )
    }

    return entity
  }
}
