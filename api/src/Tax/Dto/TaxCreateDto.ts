import { TaxTypeEnum } from '../Enums/TaxTypeEnum'
import { TaxValueTypeEnum } from '../Enums/TaxValueTypeEnum'

export interface TaxCreateDto {
  label: string
  type: TaxTypeEnum
  valueType: TaxValueTypeEnum
  value: number
  valueDetails: number
}
