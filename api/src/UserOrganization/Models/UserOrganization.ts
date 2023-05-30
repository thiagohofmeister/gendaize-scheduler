import { randomUUID } from 'crypto'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { UserRoleTypeEnum } from '../../User/Enums/UserRoleTypeEnum'
import { User } from '../../User/Models/User'
import { UserOrganizationStatusEnum } from '../Enums/UserOrganizationStatusEnum'
import { UserOrganizationDao } from './UserOrganizationDao'

export class UserOrganization implements ResponseModel, DomainModel {
  constructor(
    private roleType: UserRoleTypeEnum,
    private status: UserOrganizationStatusEnum,
    private user: User,
    private organization: Organization,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public setId(id: string): void {
    this.id = id
  }

  public getOrganization(): Organization {
    return this.organization
  }

  public setOrganization(organization: Organization): this {
    this.organization = organization
    return this
  }

  public getUser(): User {
    return this.user
  }

  public setUser(user: User): void {
    this.user = user
  }

  public getStatus(): UserOrganizationStatusEnum {
    return this.status
  }

  public setStatus(status: UserOrganizationStatusEnum): void {
    this.status = status
  }

  public getRoleType(): UserRoleTypeEnum {
    return this.roleType
  }

  public setRoleType(roleType: UserRoleTypeEnum): void {
    this.roleType = roleType
  }

  toView() {
    return {
      id: this.getId(),
      roleType: this.getRoleType(),
      status: this.getStatus(),
      user: this.getUser()?.toView(),
      organization: this.getOrganization()?.toView()
    }
  }

  toDao() {
    return new UserOrganizationDao(
      this.getId(),
      this.getStatus(),
      this.getRoleType(),
      this.getUser()?.toDao(),
      this.getOrganization()?.toDao()
    )
  }
}
