import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { TaxCreateDto } from './Dto/TaxCreateDto'
import { TaxTypeEnum } from './Enums/TaxTypeEnum'
import { TaxValueTypeEnum } from './Enums/TaxValueTypeEnum'

export class TaxValidator extends BaseValidator {
  private createSchema: Schema

  constructor() {
    super()

    this.createSchema = Joi.object({
      label: Joi.string().required(),
      type: Joi.valid(...Object.keys(TaxTypeEnum)).required(),
      valueType: Joi.valid(...Object.keys(TaxValueTypeEnum)).required(),
      value: Joi.number().required(),
      valueDetails: Joi.number().allow(null)
    })
  }

  async validateCreatePayload(payload: TaxCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }
}
