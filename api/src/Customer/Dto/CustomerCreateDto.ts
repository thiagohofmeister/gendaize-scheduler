import { CustomerCreateAddressDto } from './CustomerCreateAddressDto'

export interface CustomerCreateDto {
  name: string
  phone: string
  email?: string
  password?: string
  address?: CustomerCreateAddressDto
}
