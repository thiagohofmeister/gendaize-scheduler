import { randomUUID } from 'crypto'
import { Configuration } from '../../Configuration/Models/Configuration'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { OrganizationConfigurationDao } from './OrganizationConfigurationDao'

export class OrganizationConfiguration implements ResponseModel, DomainModel {
  constructor(
    private value: string,
    private configuration: Configuration,
    private organization: Organization,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public getOrganization(): Organization {
    return this.organization
  }

  public getConfiguration(): Configuration {
    return this.configuration
  }

  public getValue(): string {
    return this.value
  }

  toView() {
    return {
      id: this.getId(),
      value: this.getValue(),
      configuration: this.getConfiguration()?.toView(),
      organization: this.getOrganization()?.toView()
    }
  }

  toDao() {
    return new OrganizationConfigurationDao(
      this.getId(),
      this.getValue(),
      this.getConfiguration()?.toDao(),
      this.getOrganization()?.toDao()
    )
  }
}
