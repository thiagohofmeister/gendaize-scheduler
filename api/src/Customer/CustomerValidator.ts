import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { CustomerCreateAddressDto } from './Dto/CustomerCreateAddressDto'
import { CustomerCreateDto } from './Dto/CustomerCreateDto'

export class CustomerValidator extends BaseValidator {
  private readonly createSchema: Schema
  private readonly createAddressSchema: Schema

  constructor() {
    super()

    this.createAddressSchema = Joi.object({
      zipCode: Joi.string().required(),
      number: Joi.string().required(),
      complement: Joi.string().optional().allow(null, '')
    })

    this.createSchema = Joi.object({
      name: Joi.string().required(),
      phone: Joi.string().required(),
      email: Joi.string().optional().allow(null),
      password: Joi.string(),
      address: this.createAddressSchema.allow(null)
    })
  }

  public async validateCreatePayload(payload: CustomerCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }

  public async validateCreateAddressPayload(payload: CustomerCreateAddressDto) {
    return this.validateBySchema(payload, this.createAddressSchema)
  }
}
