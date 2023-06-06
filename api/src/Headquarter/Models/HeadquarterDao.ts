import {
  Column,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  PrimaryColumn
} from 'typeorm'
import { LocationDao } from '../../Location/Models/LocationDao'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { Headquarter } from './Headquarter'
import { HeadquarterSchedule } from './HeadquarterSchedule'

@Entity('headquarter')
export class HeadquarterDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  name: string

  @Column({
    name: 'address_state'
  })
  addressState: string

  @Column({
    name: 'address_city'
  })
  addressCity: string

  @Column({
    name: 'address_district'
  })
  addressDistrict: string

  @Column({
    name: 'address_street'
  })
  addressStreet: string

  @Column({
    name: 'address_number'
  })
  addressNumber: string

  @Column({
    name: 'address_complement'
  })
  addressComplement: string

  @Column({
    name: 'address_zip_code'
  })
  addressZipCode: string

  @Column('json')
  schedules: HeadquarterSchedule

  @ManyToOne(() => OrganizationDao, organization => organization.headquarters)
  @JoinColumn({
    name: 'organization_id'
  })
  organization: OrganizationDao

  @ManyToMany(() => LocationDao, { cascade: true })
  @JoinTable({
    name: 'headquarter_location',
    joinColumn: {
      name: 'headquarter_id'
    },
    inverseJoinColumn: {
      name: 'location_id'
    }
  })
  locations: LocationDao[]

  constructor(
    id: string,
    name: string,
    addressState: string,
    addressCity: string,
    addressDistrict: string,
    addressStreet: string,
    addressNumber: string,
    addressComplement: string,
    addressZipCode: string,
    schedules: HeadquarterSchedule,
    organization?: OrganizationDao
  ) {
    this.id = id
    this.name = name
    this.addressState = addressState
    this.addressCity = addressCity
    this.addressDistrict = addressDistrict
    this.addressStreet = addressStreet
    this.addressNumber = addressNumber
    this.addressComplement = addressComplement
    this.addressZipCode = addressZipCode
    this.schedules = schedules
    this.organization = organization
  }

  toDomain() {
    const domain = new Headquarter(
      this.name,
      this.addressState,
      this.addressCity,
      this.addressDistrict,
      this.addressStreet,
      this.addressNumber,
      this.addressComplement,
      this.addressZipCode,
      this.schedules,
      this.organization?.toDomain(),
      this.id
    )

    if (this.locations) {
      this.locations.forEach(location => domain.addLocation(location.toDomain()))
    }

    return domain
  }
}
