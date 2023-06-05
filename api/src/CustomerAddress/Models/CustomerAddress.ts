import { randomUUID } from 'crypto'
import { Customer } from '../../Customer/Models/Customer'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { CustomerAddressDao } from './CustomerAddressDao'
import { CustomerAddressDistance } from './CustomerAddressDistance'

export class CustomerAddress implements DomainModel, ResponseModel {
  constructor(
    private state: string,
    private city: string,
    private district: string,
    private street: string,
    private number: string,
    private complement: string,
    private zipCode: string,
    private distances: CustomerAddressDistance[],
    private customer?: Customer,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public getCustomer(): Customer {
    return this.customer
  }

  public getDistances(): CustomerAddressDistance[] {
    return this.distances
  }

  public getZipCode(): string {
    return this.zipCode
  }

  public getComplement(): string {
    return this.complement
  }

  public getNumber(): string {
    return this.number
  }

  public getStreet(): string {
    return this.street
  }

  public getDistrict(): string {
    return this.district
  }

  public getCity(): string {
    return this.city
  }

  public getState(): string {
    return this.state
  }

  toView() {
    return {
      state: this.getState(),
      city: this.getCity(),
      district: this.getDistrict(),
      street: this.getStreet(),
      number: this.getNumber(),
      complement: this.getComplement(),
      zipCode: this.getZipCode(),
      distances: this.getDistances(),
      customer: this.getCustomer()?.toView(),
      id: this.getId()
    }
  }

  toDao() {
    return new CustomerAddressDao(
      this.getId(),
      this.getState(),
      this.getCity(),
      this.getDistrict(),
      this.getStreet(),
      this.getNumber(),
      this.getComplement(),
      this.getZipCode(),
      this.getDistances(),
      this.getCustomer()?.toDao()
    )
  }
}
