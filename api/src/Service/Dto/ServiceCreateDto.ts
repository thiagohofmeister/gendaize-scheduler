import { ServiceTypeEnum } from '../Enums/ServiceTypeEnum'
import { ServiceUpdateTaxDto } from './ServiceUpdateTaxDto'
import { ServiceUpdateUserDto } from './ServiceUpdateUserDto'

export interface ServiceCreateDto {
  name: string
  price: number
  type: ServiceTypeEnum
  sameTimeQuantity: number
  users: ServiceUpdateUserDto[]
  taxes: ServiceUpdateTaxDto[]
}
