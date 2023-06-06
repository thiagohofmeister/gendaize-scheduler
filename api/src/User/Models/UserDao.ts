import {
  Column,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  OneToMany,
  PrimaryColumn
} from 'typeorm'
import { ServiceDao } from '../../Service/Models/ServiceDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { UserOrganizationDao } from '../../UserOrganization/Models/UserOrganizationDao'
import { UserStatusEnum } from '../Enums/UserStatusEnum'
import { User } from './User'

@Entity('user')
export class UserDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  name: string

  @Column({
    name: 'document_number'
  })
  documentNumber: string

  @Column()
  email: string

  @Column()
  password: string

  @Column({
    type: 'enum',
    enum: UserStatusEnum
  })
  status: UserStatusEnum

  @OneToMany(() => UserOrganizationDao, userOrganization => userOrganization.user, {
    cascade: true
  })
  @JoinColumn({
    name: 'user_id'
  })
  userOrganizations: UserOrganizationDao[]

  @ManyToMany(() => ServiceDao, { cascade: true })
  @JoinTable({
    name: 'service_user',
    joinColumn: {
      name: 'user_id'
    },
    inverseJoinColumn: {
      name: 'service_id'
    }
  })
  services: ServiceDao[]

  constructor(
    id: string,
    name: string,
    documentNumber: string,
    email: string,
    password: string,
    status: UserStatusEnum
  ) {
    this.id = id
    this.name = name
    this.documentNumber = documentNumber
    this.email = email
    this.password = password
    this.status = status
  }

  toDomain() {
    const user = new User(
      this.name,
      this.documentNumber,
      this.email,
      this.password,
      this.status,
      this.id
    )

    if (this.userOrganizations) {
      this.userOrganizations.map(usrOrg => user.addOrganization(usrOrg.toDomain()))
    }

    return user
  }
}
