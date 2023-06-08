import { randomUUID } from 'crypto'
import { CustomerAddress } from '../../CustomerAddress/Models/CustomerAddress'
import { Organization } from '../../Organization/Models/Organization'
import { Scheduled } from '../../Scheduled/Models/Scheduled'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { EncryptUtils } from '../../Shared/Utils/EncryptUtils'
import { CustomerDao } from './CustomerDao'

export class Customer implements ResponseModel, DomainModel {
  private addresses: CustomerAddress[]
  private scheduleds: Scheduled[]

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

  public setPassword(password: string) {
    this.password = EncryptUtils.password(password)
    return this
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

  public getAddress(addressId: string) {
    return this.getAddresses().find(address => address.getId() === addressId)
  }

  public getAddresses(): CustomerAddress[] {
    return this.addresses
  }

  public removeAddresses(idsToKeep: string[]) {
    if (!this.addresses) this.addresses = []

    this.addresses = this.addresses.filter(address => idsToKeep.includes(address.getId()))

    return this
  }

  public addAddress(address: CustomerAddress) {
    if (!this.addresses) this.addresses = []

    this.addresses.push(address)

    return this
  }

  public getScheduleds(): Scheduled[] {
    return this.scheduleds
  }

  public removeScheduleds(idsToKeep: string[]) {
    if (!this.scheduleds) this.scheduleds = []

    this.scheduleds = this.scheduleds.filter(org => idsToKeep.includes(org.getId()))

    return this.scheduleds
  }

  public addScheduled(scheduled: Scheduled) {
    if (!this.scheduleds) this.scheduleds = []
    this.scheduleds.push(scheduled)
    return this
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      phone: this.getPhone(),
      email: this.getEmail(),
      organization: this.getOrganization()?.toView(),
      addresses: this.getAddresses()?.map(address => address.toView()) || []
    }
  }

  toDao() {
    const entity = new CustomerDao(
      this.getId(),
      this.getName(),
      this.getPhone(),
      this.getEmail(),
      this.getPassword(),
      this.getOrganization()?.toDao()
    )

    if (this.getAddresses()) {
      entity.addresses = this.getAddresses().map(address => address.toDao())
    }

    return entity
  }
}
