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
      this.getValue(),
      this.getValueDetails(),
      this.getOrganization()?.toDao()
    )
  }
}
