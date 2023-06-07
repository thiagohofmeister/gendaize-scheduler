import { randomUUID } from 'crypto'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { Tax } from '../../Tax/Models/Tax'
import { User } from '../../User/Models/User'
import { ServiceTypeEnum } from '../Enums/ServiceTypeEnum'
import { ServiceDao } from './ServiceDao'

export class Service implements DomainModel, ResponseModel {
  private users: User[]
  private taxes: Tax[]

  constructor(
    private name: string,
    private price: number,
    private type: ServiceTypeEnum,
    private sameTimeQuantity: number,
    private organization?: Organization,
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

  public getSameTimeQuantity(): number {
    return this.sameTimeQuantity
  }

  public getType(): ServiceTypeEnum {
    return this.type
  }

  public getPrice(): number {
    return this.price
  }

  public getName(): string {
    return this.name
  }

  public getUsers() {
    return this.users
  }

  public removeUsers(idsToKeep: string[]): this {
    if (!this.users) this.users = []
    this.users = this.users.filter(user => idsToKeep.includes(user.getId()))
    return this
  }

  public addUser(user: User) {
    if (!this.users) this.users = []
    this.users.push(user)
    return this
  }

  public getTaxes() {
    return this.taxes
  }

  public removeTaxes(idsToKeep: string[]): this {
    if (!this.taxes) this.taxes = []
    this.taxes = this.taxes.filter(tax => idsToKeep.includes(tax.getId()))
    return this
  }

  public addTax(tax: Tax) {
    if (!this.taxes) this.taxes = []
    this.taxes.push(tax)
    return this
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      price: this.getPrice(),
      type: this.getType(),
      sameTimeQuantity: this.getSameTimeQuantity(),
      organization: this.getOrganization()?.toView(),
      users: this.getUsers()?.map(user => user.toView()) || [],
      taxes: this.getTaxes()?.map(user => user.toView()) || []
    }
  }

  toDao() {
    const entity = new ServiceDao(
      this.getId(),
      this.getName(),
      this.getPrice(),
      this.getType(),
      this.getSameTimeQuantity(),
      this.getOrganization()?.toDao()
    )

    if (this.getUsers()) {
      entity.users = this.getUsers().map(user => user.toDao())
    }

    if (this.getTaxes()) {
      entity.taxes = this.getTaxes().map(tax => tax.toDao())
    }

    return entity
  }
}
