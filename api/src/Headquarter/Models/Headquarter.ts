import { randomUUID } from 'crypto'
import { Location } from '../../Location/Models/Location'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { HeadquarterDao } from './HeadquarterDao'
import { HeadquarterSchedule } from './HeadquarterSchedule'

export class Headquarter implements DomainModel, ResponseModel {
  private locations: Location[]

  constructor(
    private name: string,
    private addressState: string,
    private addressCity: string,
    private addressDistrict: string,
    private addressStreet: string,
    private addressNumber: string,
    private addressComplement: string,
    private addressZipCode: string,
    private schedules: HeadquarterSchedule,
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

  public getSchedules(): HeadquarterSchedule {
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

  public getLocations() {
    return this.locations
  }

  public removeLocations(idsToKeep: string[]): this {
    if (!this.locations) this.locations = []
    this.locations = this.locations.filter(location => idsToKeep.includes(location.getId()))
    return this
  }

  public addLocation(location: Location) {
    if (!this.locations) this.locations = []
    this.locations.push(location)
    return this
  }

  toView() {
    return {
      id: this.getId(),
      name: this.getName(),
      address: {
        state: this.getAddressState(),
        city: this.getAddressCity(),
        district: this.getAddressDistrict(),
        street: this.getAddressStreet(),
        number: this.getAddressNumber(),
        complement: this.getAddressComplement(),
        zipCode: this.getAddressZipCode()
      },
      schedules: this.getSchedules(),
      organization: this.getOrganization()?.toView(),
      locations: this.getLocations()?.map(location => location.toView()) || []
    }
  }

  toDao() {
    const entity = new HeadquarterDao(
      this.getId(),
      this.getName(),
      this.getAddressState(),
      this.getAddressCity(),
      this.getAddressDistrict(),
      this.getAddressStreet(),
      this.getAddressNumber(),
      this.getAddressComplement(),
      this.getAddressZipCode(),
      this.getSchedules(),
      this.getOrganization()?.toDao()
    )

    if (this.getLocations()) {
      entity.locations = this.getLocations()?.map(location => location.toDao())
    }

    return entity
  }
}
