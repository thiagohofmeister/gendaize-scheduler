import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm'
import { CustomerDao } from '../../Customer/Models/CustomerDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { CustomerAddress } from './CustomerAddress'
import { CustomerAddressDistance } from './CustomerAddressDistance'

@Entity('customer_address')
export class CustomerAddressDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  state: string

  @Column()
  city: string

  @Column()
  district: string

  @Column()
  street: string

  @Column()
  number: string

  @Column()
  complement: string

  @Column({
    name: 'zip_code'
  })
  zipCode: string

  @Column('json')
  distances: CustomerAddressDistance[]

  @ManyToOne(() => CustomerDao, customer => customer.addresses)
  @JoinColumn({
    name: 'customer_id'
  })
  customer: CustomerDao

  constructor(
    id: string,
    state: string,
    city: string,
    district: string,
    street: string,
    number: string,
    complement: string,
    zipCode: string,
    distances: CustomerAddressDistance[],
    customer?: CustomerDao
  ) {
    this.id = id
    this.state = state
    this.city = city
    this.district = district
    this.street = street
    this.number = number
    this.complement = complement
    this.zipCode = zipCode
    this.distances = distances
    this.customer = customer
  }

  toDomain() {
    return new CustomerAddress(
      this.state,
      this.city,
      this.district,
      this.street,
      this.number,
      this.complement,
      this.zipCode,
      this.distances,
      this.customer?.toDomain(),
      this.id
    )
  }
}
