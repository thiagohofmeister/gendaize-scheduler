import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm'
import { CustomerDao } from '../../Customer/Models/CustomerDao'
import { HeadquarterDao } from '../../Headquarter/Models/HeadquarterDao'
import { ServiceDao } from '../../Service/Models/ServiceDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { UserDao } from '../../User/Models/UserDao'
import { ScheduledStatusEnum } from '../Enums/ScheduledStatusEnum'
import { Scheduled } from './Scheduled'
import { ScheduledAddress } from './ScheduledAddress'
import { ScheduledAmount } from './ScheduledAmount'

@Entity('scheduled')
export class ScheduledDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column({
    name: 'start_at'
  })
  startAt: Date

  @Column({
    name: 'end_at'
  })
  endAt: Date

  @Column({
    type: 'enum',
    enum: ScheduledStatusEnum
  })
  status: ScheduledStatusEnum

  @Column('json')
  addresses: ScheduledAddress

  @Column('json')
  amount: ScheduledAmount

  @ManyToOne(() => UserDao, user => user.scheduleds)
  @JoinColumn({
    name: 'user_id'
  })
  user: UserDao

  @ManyToOne(() => CustomerDao, customer => customer.scheduleds)
  @JoinColumn({
    name: 'customer_id'
  })
  customer: CustomerDao

  @ManyToOne(() => ServiceDao)
  @JoinColumn({
    name: 'service_id'
  })
  service: ServiceDao

  @ManyToOne(() => HeadquarterDao)
  @JoinColumn({
    name: 'headquarter_id'
  })
  headquarter: HeadquarterDao

  @Column({
    name: 'created_at'
  })
  createdAt: Date

  constructor(
    id: string,
    startAt: Date,
    endAt: Date,
    status: ScheduledStatusEnum,
    addresses: ScheduledAddress,
    amount: ScheduledAmount,
    user: UserDao,
    customer: CustomerDao,
    service: ServiceDao,
    headquarter: HeadquarterDao,
    createdAt: Date
  ) {
    this.id = id
    this.startAt = startAt
    this.endAt = endAt
    this.status = status
    this.addresses = addresses
    this.amount = amount
    this.user = user
    this.customer = customer
    this.service = service
    this.headquarter = headquarter
    this.createdAt = createdAt
  }

  toDomain() {
    return new Scheduled(
      this.startAt,
      this.endAt,
      this.status,
      this.addresses,
      this.amount,
      this.user?.toDomain(),
      this.customer?.toDomain(),
      this.service?.toDomain(),
      this.headquarter?.toDomain(),
      this.id,
      this.createdAt
    )
  }
}
