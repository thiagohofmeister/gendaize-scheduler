import { OrganizationCreateDto } from '../../Organization/Dto/OrganizationCreateDto'
import { UserCreateDto } from '../../User/Dto/UserCreateDto'

export interface RegisterCreateDto {
  device: string
  isCustomer: boolean
  user: UserCreateDto
  organization: OrganizationCreateDto
}
