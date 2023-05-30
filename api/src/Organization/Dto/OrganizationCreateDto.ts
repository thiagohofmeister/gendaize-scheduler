import { DocumentTypeEnum } from '../Enums/DocumentTypeEnum'

export interface OrganizationCreateDto {
  name: string
  document: {
    type: DocumentTypeEnum
    number: string
    name: string
  }
  email: string
  phone: string
}
