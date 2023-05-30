import { randomUUID } from 'crypto'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { UserOrganization } from '../../UserOrganization/Models/UserOrganization'
import { AuthenticationStatusEnum } from '../Enums/AuthenticationStatusEnum'
import { AuthenticationDao } from './AuthenticationDao'

export class Authentication implements ResponseModel, DomainModel {
  constructor(
    private token: string,
    private device: string,
    private status: AuthenticationStatusEnum,
    private userOrganization: UserOrganization,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  getToken(): string {
    return this.token
  }

  getDevice(): string {
    return this.device
  }

  getStatus(): AuthenticationStatusEnum {
    return this.status
  }

  getUserOrganization(): UserOrganization {
    return this.userOrganization
  }

  getId(): string {
    return this.id
  }

  toView() {
    return {
      id: this.getId(),
      token: this.getToken(),
      device: this.getDevice(),
      status: this.getStatus(),
      userOrganization: this.getUserOrganization()?.toView()
    }
  }

  toDao() {
    return new AuthenticationDao(
      this.getId(),
      this.getDevice(),
      this.getStatus(),
      this.getToken(),
      this.getUserOrganization()?.toDao()
    )
  }
}
