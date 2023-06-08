import { randomUUID } from 'crypto'
import { Customer } from '../../Customer/Models/Customer'
import { Headquarter } from '../../Headquarter/Models/Headquarter'
import { Service } from '../../Service/Models/Service'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { User } from '../../User/Models/User'
import { ScheduledStatusEnum } from '../Enums/ScheduledStatusEnum'
import { ScheduledAddress } from './ScheduledAddress'
import { ScheduledAmount } from './ScheduledAmount'
import { ScheduledDao } from './ScheduledDao'

export class Scheduled implements DomainModel, ResponseModel {
  constructor(
    private startAt: Date,
    private endAt: Date,
    private status: ScheduledStatusEnum,
    private addresses: ScheduledAddress,
    private amount: ScheduledAmount,
    private user?: User,
    private customer?: Customer,
    private service?: Service,
    private headquarter?: Headquarter,
    private id?: string,
    private createdAt?: Date
  ) {
    if (!id) this.id = randomUUID()
  }

  public getCreatedAt(): Date {
    return this.createdAt
  }

  public getId(): string {
    return this.id
  }

  public getHeadquarter(): Headquarter {
    return this.headquarter
  }

  public getService(): Service {
    return this.service
  }

  public getCustomer(): Customer {
    return this.customer
  }

  public getUser(): User {
    return this.user
  }

  public getAmount(): ScheduledAmount {
    return this.amount
  }

  public getAddresses(): ScheduledAddress {
    return this.addresses
  }

  public getStatus(): ScheduledStatusEnum {
    return this.status
  }

  public getEndAt(): Date {
    return this.endAt
  }

  public getStartAt(): Date {
    return this.startAt
  }

  toView() {
    return {
      id: this.getId(),
      startAt: this.getStartAt(),
      endAt: this.getEndAt(),
      status: this.getStatus(),
      addresses: this.getAddresses(),
      amount: this.getAmount(),
      user: this.getUser()?.toView(),
      customer: this.getCustomer()?.toView(),
      service: this.getService()?.toView(),
      headquarter: this.getHeadquarter()?.toView(),
      createdAt: this.getCreatedAt()
    }
  }

  toDao() {
    return new ScheduledDao(
      this.getId(),
      this.getStartAt(),
      this.getEndAt(),
      this.getStatus(),
      this.getAddresses(),
      this.getAmount(),
      this.getUser()?.toDao(),
      this.getCustomer()?.toDao(),
      this.getService()?.toDao(),
      this.getHeadquarter()?.toDao(),
      this.getCreatedAt()
    )
  }
}
