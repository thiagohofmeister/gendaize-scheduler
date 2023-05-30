import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm'
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
    userOrganization: UserOrganizationDao
  ) {
    this.id = id
    this.device = device
    this.status = status
    this.token = token
    this.userOrganization = userOrganization
  }

  toDomain() {
    return new Authentication(
      this.token,
      this.device,
      this.status,
      this.userOrganization?.toDomain(),
      this.id
    )
  }
}
