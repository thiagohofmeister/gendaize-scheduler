import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm'
import { CustomerDao } from '../../Customer/Models/CustomerDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { UserOrganizationDao } from '../../UserOrganization/Models/UserOrganizationDao'
import { AuthenticationStatusEnum } from '../Enums/AuthenticationStatusEnum'
import { Authentication } from './Authentication'

@Entity('authentication')
export class AuthenticationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @ManyToOne(() => UserOrganizationDao, userOrganization => userOrganization.authentications, {
    cascade: false
  })
  @JoinColumn({
    name: 'user_organization_id'
  })
  userOrganization: UserOrganizationDao

  @ManyToOne(() => CustomerDao, customer => customer.authentications, {
    cascade: false
  })
  @JoinColumn({
    name: 'customer_id'
  })
  customer: CustomerDao

  @Column()
  device: string

  @Column()
  token: string

  @Column({
    type: 'enum',
    enum: AuthenticationStatusEnum
  })
  status: AuthenticationStatusEnum

  constructor(
    id: string,
    device: string,
    status: AuthenticationStatusEnum,
    token: string,
    userOrganization?: UserOrganizationDao,
    customer?: CustomerDao
  ) {
    this.id = id
    this.device = device
    this.status = status
    this.token = token
    this.userOrganization = userOrganization
    this.customer = customer
  }

  toDomain() {
    return new Authentication(
      this.token,
      this.device,
      this.status,
      this.userOrganization?.toDomain(),
      this.customer?.toDomain(),
      this.id
    )
  }
}
