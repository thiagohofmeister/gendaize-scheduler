import { randomUUID } from 'crypto'

import { Headquarter } from '../../Headquarter/Models/Headquarter'
import { OrganizationConfiguration } from '../../OrganizationConfiguration/Models/OrganizationConfiguration'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { DocumentTypeEnum } from '../Enums/DocumentTypeEnum'
import { OrganizationDao } from './OrganizationDao'

export class Organization implements ResponseModel, DomainModel {
  private organizationConfigurations: OrganizationConfiguration[]
  private headquarters: Headquarter[]

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

  public getConfigurations(): OrganizationConfiguration[] {
    return this.organizationConfigurations
  }

  public removeConfigurations(idsToKeep: string[]) {
    if (!this.organizationConfigurations) this.organizationConfigurations = []

    this.organizationConfigurations = this.organizationConfigurations.filter(
      config => !idsToKeep.includes(config.getId())
    )

    return this.organizationConfigurations
  }

  public addConfiguration(organizationConfiguration: OrganizationConfiguration) {
    if (!this.organizationConfigurations) this.organizationConfigurations = []
    this.organizationConfigurations.push(organizationConfiguration)
    return this
  }

  public getHeadquarters(): Headquarter[] {
    return this.headquarters
  }

  public removeHeadquarters(idsToKeep: string[]) {
    if (!this.headquarters) this.headquarters = []

    this.headquarters = this.headquarters.filter(config => !idsToKeep.includes(config.getId()))

    return this.headquarters
  }

  public addHeadquarter(Headquarter: Headquarter) {
    if (!this.headquarters) this.headquarters = []
    this.headquarters.push(Headquarter)
    return this
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
      phone: this.getPhone(),
      configurations: this.getConfigurations()?.map(config => config.toView()),
      headquarters: this.getHeadquarters()?.map(headquarter => headquarter.toView())
    }
  }

  toDao() {
    const organization = new OrganizationDao(
      this.getId(),
      this.getName(),
      this.getDocumentType(),
      this.getDocumentNumber(),
      this.getDocumentName(),
      this.getEmail(),
      this.getPhone()
    )

    if (this.getConfigurations()) {
      organization.organizationConfigurations = this.getConfigurations().map(config =>
        config.toDao()
      )
    }

    if (this.getHeadquarters()) {
      organization.headquarters = this.getHeadquarters().map(headquarter => headquarter.toDao())
    }

    return organization
  }
}
