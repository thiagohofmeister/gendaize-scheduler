import { randomUUID } from 'crypto'
import { Organization } from '../../Organization/Models/Organization'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { TaxTypeEnum } from '../Enums/TaxTypeEnum'
import { TaxValueTypeEnum } from '../Enums/TaxValueTypeEnum'
import { TaxDao } from './TaxDao'

export class Tax implements DomainModel, ResponseModel {
  constructor(
    private label: string,
    private type: TaxTypeEnum,
    private valueType: TaxValueTypeEnum,
    private value: number,
    private valueDetails: number,
    private organization?: Organization,
    private id?: string
  ) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public getOrganization(): Organization {
    return this.organization
  }

  public getValueDetails(): any {
    return this.valueDetails
  }

  public getValue(): number {
    return this.value
  }

  public getValueType(): TaxValueTypeEnum {
    return this.valueType
  }

  public getType(): TaxTypeEnum {
    return this.type
  }

  public getLabel(): string {
    return this.label
  }

  public getFinalValue(subtotal: number, distance: number): number {
    switch (this.valueType) {
      case TaxValueTypeEnum.DISTANCE:
        return (this.value / 100) * Math.floor(distance / this.getValueDetails()) + subtotal

      case TaxValueTypeEnum.FIXED:
        return this.value / 100 + subtotal

      case TaxValueTypeEnum.PERCENT:
        return (subtotal * this.value) / 100
    }
  }

  toView() {
    return {
      id: this.getId(),
      label: this.getLabel(),
      type: this.getType(),
      valueType: this.getValueType(),
      value: this.getValue(),
      valueDetails: this.getValueDetails(),
      organization: this.getOrganization()?.toView()
    }
  }

  toDao() {
    return new TaxDao(
      this.getId(),
      this.getLabel(),
      this.getType(),
      this.getValueType(),
      this.getValueType() == TaxValueTypeEnum.PERCENT ? this.getValue() : this.getValue() * 100,
      this.getValueDetails(),
      this.getOrganization()?.toDao()
    )
  }
}
