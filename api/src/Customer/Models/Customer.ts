import { randomUUID } from 'crypto'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { CustomerDao } from './CustomerDao'

export class Customer implements ResponseModel, DomainModel {
  constructor(
    private name: string,
    private phone: string,
    private email: string,
    private password: string,
    private organization: Organization,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public getPassword(): string {
    return this.password
  }

  public getEmail(): string {
    return this.email
  }

  public getPhone(): string {
    return this.phone
  }

  public getName(): string {
    return this.name
  }

  public getOrganization(): Organization {
    return this.organization
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      phone: this.getPhone(),
      email: this.getEmail(),
      organization: this.getOrganization()?.toView()
    }
  }

  toDao() {
    return new CustomerDao(
      this.getId(),
      this.getName(),
      this.getPhone(),
      this.getEmail(),
      this.getPassword(),
      this.getOrganization()?.toDao()
    )
  }
}
