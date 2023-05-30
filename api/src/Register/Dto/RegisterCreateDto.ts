import { OrganizationCreateDto } from '../../Organization/Dto/OrganizationCreateDto'
import { UserCreateDto } from '../../User/Dto/UserCreateDto'

export interface RegisterCreateDto {
  user: UserCreateDto
  organization: OrganizationCreateDto
}
