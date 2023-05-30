import { randomUUID } from 'crypto'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { EncryptUtils } from '../../Shared/Utils/EncryptUtils'
import { UserOrganization } from '../../UserOrganization/Models/UserOrganization'
import { UserStatusEnum } from '../Enums/UserStatusEnum'
import { UserDao } from './UserDao'

export class User implements ResponseModel, DomainModel {
  private organizations: UserOrganization[]

  constructor(
    private name: string,
    private documentNumber: string,
    private email: string,
    private password: string,
    private status: UserStatusEnum = UserStatusEnum.ACTIVE,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getStatus(): UserStatusEnum {
    return this.status
  }

  public setStatus(status: UserStatusEnum) {
    this.status = status
    return this
  }

  public getPassword(): string {
    return this.password
  }

  public setPassword(password: string) {
    this.password = EncryptUtils.password(password)
    return this
  }

  public getEmail(): string {
    return this.email
  }

  public setEmail(email: string) {
    this.email = email
    return this
  }

  public getDocumentNumber(): string {
    return this.documentNumber
  }

  public setDocumentNumber(documentNumber: string) {
    this.documentNumber = documentNumber
    return this
  }

  public getName(): string {
    return this.name
  }

  public setName(name: string) {
    this.name = name
    return this
  }

  public getId(): string {
    return this.id
  }

  public removeOrganizations(keepOrganizationIds: string[]) {
    if (!this.organizations) this.organizations = []

    this.organizations = this.organizations.filter(
      org => !keepOrganizationIds.includes(org.getId())
    )

    return this.organizations
  }

  public addOrganization(userOrganization: UserOrganization) {
    if (!this.organizations) this.organizations = []
    this.organizations.push(userOrganization)
    return this
  }

  public getAllOrganizations(): UserOrganization[] {
    return this.organizations
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      documentNumber: this.getDocumentNumber(),
      email: this.getEmail(),
      status: this.getStatus()
    }
  }

  toDao() {
    const user = new UserDao(
      this.getId(),
      this.getName(),
      this.getDocumentNumber(),
      this.getEmail(),
      this.getPassword(),
      this.getStatus()
    )

    if (this.getAllOrganizations()) {
      user.userOrganizations = this.getAllOrganizations().map(userOrg => userOrg.toDao())
    }

    return user
  }
}
