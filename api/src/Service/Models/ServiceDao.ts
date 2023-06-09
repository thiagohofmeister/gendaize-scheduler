import {
  Column,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  PrimaryColumn
} from 'typeorm'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { TaxDao } from '../../Tax/Models/TaxDao'
import { UserDao } from '../../User/Models/UserDao'
import { ServiceTypeEnum } from '../Enums/ServiceTypeEnum'
import { Service } from './Service'

@Entity('service')
export class ServiceDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  name: string

  @Column()
  price: number

  @Column({
    type: 'enum',
    enum: ServiceTypeEnum
  })
  type: ServiceTypeEnum

  @Column({
    name: 'same_time_quantity'
  })
  sameTimeQuantity: number

  @Column()
  duration: number

  @ManyToOne(() => OrganizationDao, organization => organization.services)
  @JoinColumn({
    name: 'organization_id'
  })
  organization?: OrganizationDao

  @ManyToMany(() => UserDao, { cascade: true })
  @JoinTable({
    name: 'service_user',
    joinColumn: {
      name: 'service_id'
    },
    inverseJoinColumn: {
      name: 'user_id'
    }
  })
  users: UserDao[]

  @ManyToMany(() => TaxDao, { cascade: true })
  @JoinTable({
    name: 'service_tax',
    joinColumn: {
      name: 'service_id'
    },
    inverseJoinColumn: {
      name: 'tax_id'
    }
  })
  taxes: TaxDao[]

  constructor(
    id: string,
    name: string,
    price: number,
    type: ServiceTypeEnum,
    sameTimeQuantity: number,
    duration: number,
    organization?: OrganizationDao
  ) {
    this.id = id
    this.name = name
    this.price = price
    this.type = type
    this.sameTimeQuantity = sameTimeQuantity
    this.duration = duration
    this.organization = organization
  }

  toDomain() {
    const domain = new Service(
      this.name,
      this.price / 100,
      this.type,
      this.sameTimeQuantity,
      this.duration,
      this.organization?.toDomain(),
      this.id
    )

    if (this.users) {
      this.users.forEach(user => domain.addUser(user.toDomain()))
    }

    if (this.taxes) {
      this.taxes.forEach(tax => domain.addTax(tax.toDomain()))
    }

    return domain
  }
}
