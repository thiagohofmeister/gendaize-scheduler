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

  constructor(
    id: string,
    name: string,
    price: number,
    type: ServiceTypeEnum,
    sameTimeQuantity: number,
    organization?: OrganizationDao
  ) {
    this.id = id
    this.name = name
    this.price = price
    this.type = type
    this.sameTimeQuantity = sameTimeQuantity
    this.organization = organization
  }

  toDomain() {
    const domain = new Service(
      this.name,
      this.price,
      this.type,
      this.sameTimeQuantity,
      this.organization?.toDomain(),
      this.id
    )

    if (this.users) {
      this.users.forEach(user => domain.addUser(user.toDomain()))
    }

    return domain
  }
}
