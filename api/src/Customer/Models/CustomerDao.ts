import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryColumn } from 'typeorm'
import { AuthenticationDao } from '../../Authentication/Models/AuthenticationDao'
import { CustomerAddressDao } from '../../CustomerAddress/Models/CustomerAddressDao'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { ScheduledDao } from '../../Scheduled/Models/ScheduledDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { Customer } from './Customer'

@Entity('customer')
export class CustomerDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  name: string

  @Column()
  phone: string

  @Column()
  email: string

  @Column()
  password: string

  @ManyToOne(() => OrganizationDao, organization => organization.userOrganizations)
  @JoinColumn({
    name: 'organization_id'
  })
  organization: OrganizationDao

  @OneToMany(() => AuthenticationDao, authentication => authentication.userOrganization)
  @JoinColumn({
    name: 'customer_id'
  })
  authentications: AuthenticationDao[]

  @OneToMany(() => CustomerAddressDao, customerAddress => customerAddress.customer, {
    cascade: true,
    onDelete: 'CASCADE'
  })
  @JoinColumn({
    name: 'customer_id'
  })
  addresses: CustomerAddressDao[]

  @OneToMany(() => ScheduledDao, scheduled => scheduled.user, {
    onDelete: 'CASCADE'
  })
  @JoinColumn({
    name: 'customer_id'
  })
  scheduleds: ScheduledDao[]

  constructor(
    id: string,
    name: string,
    phone: string,
    email: string,
    password: string,
    organization: OrganizationDao
  ) {
    this.id = id
    this.name = name
    this.phone = phone
    this.email = email
    this.password = password
    this.organization = organization
  }

  toDomain() {
    const domain = new Customer(
      this.name,
      this.phone,
      this.email,
      this.password,
      this.organization?.toDomain(),
      this.id
    )

    if (this.addresses) {
      this.addresses.forEach(address => domain.addAddress(address.toDomain()))
    }

    if (this.scheduleds) {
      this.scheduleds.forEach(scheduled => domain.addScheduled(scheduled.toDomain()))
    }

    return domain
  }
}
