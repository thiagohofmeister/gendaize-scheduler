import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { CustomerCreateDto } from './Dto/CustomerCreateDto'

export class CustomerValidator extends BaseValidator {
  private readonly createSchema: Schema

  constructor() {
    super()

    this.createSchema = Joi.object({
      name: Joi.string().required(),
      phone: Joi.string().required(),
      email: Joi.string().optional().allow(null),
      password: Joi.string(),
      address: Joi.object({
        zipCode: Joi.string().required(),
        number: Joi.string().required(),
        complement: Joi.string().allow(null)
      }).allow(null)
    })
  }

  public async validateCreatePayload(payload: CustomerCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }
}
