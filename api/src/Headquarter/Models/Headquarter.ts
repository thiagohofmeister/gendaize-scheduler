import { randomUUID } from 'crypto'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'

export class Headquarter implements DomainModel, ResponseModel {
  constructor(
    private name: string,
    private addressState: string,
    private addressCity: string,
    private addressDistrict: string,
    private addressStreet: string,
    private addressNumber: string,
    private addressComplement: string,
    private addressZipCode: string,
    private schedules: string,
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

  public getSchedules(): string {
    return this.schedules
  }

  public getAddressZipCode(): string {
    return this.addressZipCode
  }

  public getAddressComplement(): string {
    return this.addressComplement
  }

  public getAddressNumber(): string {
    return this.addressNumber
  }

  public getAddressStreet(): string {
    return this.addressStreet
  }

  public getAddressDistrict(): string {
    return this.addressDistrict
  }

  public getAddressCity(): string {
    return this.addressCity
  }

  public getAddressState(): string {
    return this.addressState
  }

  public getName(): string {
    return this.name
  }

  public getFullAddress() {
    const infos = [
      this.getAddressStreet(),
      this.getAddressNumber(),
      this.getAddressCity(),
      this.getAddressZipCode()
    ]

    return infos.filter(i => !!i).join(' ')
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      addressState: this.getAddressState(),
      addressCity: this.getAddressCity(),
      addressDistrict: this.getAddressDistrict(),
      addressStreet: this.getAddressStreet(),
      addressNumber: this.getAddressNumber(),
      addressComplement: this.getAddressComplement(),
      addressZipCode: this.getAddressZipCode(),
      schedules: this.getSchedules(),
      organization: this.getOrganization()
    }
  }

  toDao() {}
}
