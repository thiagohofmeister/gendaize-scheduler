import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryColumn } from 'typeorm'
import { AuthenticationDao } from '../../Authentication/Models/AuthenticationDao'
import { OrganizationDao } from '../../Organization/Models/OrganizationDao'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { UserRoleTypeEnum } from '../../User/Enums/UserRoleTypeEnum'
import { UserDao } from '../../User/Models/UserDao'
import { UserOrganizationStatusEnum } from '../Enums/UserOrganizationStatusEnum'
import { UserOrganization } from './UserOrganization'

@Entity('user_organization')
export class UserOrganizationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @ManyToOne(() => UserDao, user => user.userOrganizations)
  @JoinColumn({
    name: 'user_id'
  })
  user: UserDao

  @ManyToOne(() => OrganizationDao, organization => organization.userOrganizations)
  @JoinColumn({
    name: 'organization_id'
  })
  organization: OrganizationDao

  @Column({
    type: 'enum',
    enum: UserRoleTypeEnum,
    name: 'role_type'
  })
  roleType: UserRoleTypeEnum

  @Column({
    type: 'enum',
    enum: UserOrganizationStatusEnum
  })
  status: UserOrganizationStatusEnum

  @OneToMany(() => AuthenticationDao, authentication => authentication.userOrganization)
  @JoinColumn({
    name: 'user_organization_id'
  })
  authentications: AuthenticationDao[]

  constructor(
    id: string,
    status: UserOrganizationStatusEnum,
    roleType: UserRoleTypeEnum,
    user: UserDao,
    organization: OrganizationDao
  ) {
    this.id = id
    this.status = status
    this.roleType = roleType
    this.user = user
    this.organization = organization
  }

  toDomain() {
    return new UserOrganization(
      this.roleType,
      this.status,
      this.user?.toDomain(),
      this.organization?.toDomain(),
      this.id
    )
  }
}
