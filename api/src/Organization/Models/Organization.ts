import { randomUUID } from 'crypto'

import { OrganizationConfiguration } from '../../OrganizationConfiguration/Models/OrganizationConfiguration'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { DocumentTypeEnum } from '../Enums/DocumentTypeEnum'
import { OrganizationDao } from './OrganizationDao'

export class Organization implements ResponseModel, DomainModel {
  private organizationConfigurations: OrganizationConfiguration[]

  constructor(
    private name: string,
    private documentType: DocumentTypeEnum,
    private documentNumber: string,
    private documentName: string,
    private email: string,
    private phone: string,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getPhone(): string {
    return this.phone
  }

  public getEmail(): string {
    return this.email
  }

  public getDocumentName(): string {
    return this.documentName
  }

  public getDocumentNumber(): string {
    return this.documentNumber
  }

  public getDocumentType(): DocumentTypeEnum {
    return this.documentType
  }

  public getName(): string {
    return this.name
  }

  public getId(): string {
    return this.id
  }

  public removeOrganizations(keepOrganizationIds: string[]) {
    if (!this.organizationConfigurations) this.organizationConfigurations = []

    this.organizationConfigurations = this.organizationConfigurations.filter(
      org => !keepOrganizationIds.includes(org.getId())
    )

    return this.organizationConfigurations
  }

  public addOrganization(organizationConfiguration: OrganizationConfiguration) {
    if (!this.organizationConfigurations) this.organizationConfigurations = []
    this.organizationConfigurations.push(organizationConfiguration)
    return this
  }

  public getOrganizationConfigurations(): OrganizationConfiguration[] {
    return this.organizationConfigurations
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      document: {
        type: this.getDocumentType(),
        number: this.getDocumentNumber(),
        name: this.getDocumentName()
      },
      email: this.getEmail(),
      phone: this.getPhone()
    }
  }

  toDao() {
    return new OrganizationDao(
      this.getId(),
      this.getName(),
      this.getDocumentType(),
      this.getDocumentNumber(),
      this.getDocumentName(),
      this.getEmail(),
      this.getPhone()
    )
  }
}
