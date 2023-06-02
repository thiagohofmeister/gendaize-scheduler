import { Column, Entity, JoinColumn, OneToMany, PrimaryColumn } from 'typeorm'

import { DaoModel } from '../../Shared/Models/DaoModel'
import { UserOrganizationDao } from '../../UserOrganization/Models/UserOrganizationDao'
import { DocumentTypeEnum } from '../Enums/DocumentTypeEnum'
import { Organization } from './Organization'

@Entity('organization')
export class OrganizationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  name: string

  @Column({
    name: 'document_type',
    type: 'enum',
    enum: DocumentTypeEnum
  })
  documentType: DocumentTypeEnum

  @Column({
    name: 'document_number'
  })
  documentNumber: string

  @Column({
    name: 'document_name'
  })
  documentName: string

  @Column()
  email: string

  @Column()
  phone: string

  @OneToMany(() => UserOrganizationDao, userOrganization => userOrganization.user)
  @JoinColumn({
    name: 'user_id'
  })
  userOrganizations: UserOrganizationDao[]

  constructor(
    id: string,
    name: string,
    documentType: DocumentTypeEnum,
    documentNumber: string,
    documentName: string,
    email: string,
    phone: string
  ) {
    this.id = id
    this.name = name
    this.documentType = documentType
    this.documentNumber = documentNumber
    this.documentName = documentName
    this.email = email
    this.phone = phone
  }

  toDomain(): Organization {
    return new Organization(
      this.name,
      this.documentType,
      this.documentNumber,
      this.documentName,
      this.email,
      this.phone,
      this.id
    )
  }
}
