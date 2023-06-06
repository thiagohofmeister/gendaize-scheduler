import { ServiceTypeEnum } from '../Enums/ServiceTypeEnum'

export interface ServiceCreateDto {
  name: string
  price: number
  type: ServiceTypeEnum
  sameTimeQuantity: number
}
