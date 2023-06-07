import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { ServiceCreateDto } from './Dto/ServiceCreateDto'
import { ServiceUpdateUserDto } from './Dto/ServiceUpdateUserDto'
import { ServiceTypeEnum } from './Enums/ServiceTypeEnum'

export class ServiceValidator extends BaseValidator {
  private updateUsersSchema: Schema
  private updateTaxesSchema: Schema
  private createSchema: Schema

  constructor() {
    super()

    this.updateUsersSchema = Joi.array().items(
      Joi.object({
        id: Joi.string().required()
      })
    )

    this.updateTaxesSchema = Joi.array().items(
      Joi.object({
        id: Joi.string().required()
      })
    )

    this.createSchema = Joi.object({
      name: Joi.string().required(),
      price: Joi.number().required(),
      type: Joi.valid(...Object.keys(ServiceTypeEnum)).required(),
      sameTimeQuantity: Joi.number().required(),
      users: this.updateUsersSchema,
      taxes: this.updateTaxesSchema
    })
  }

  async validateCreatePayload(payload: ServiceCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }

  async validateUpdateUsersPayload(payload: ServiceUpdateUserDto[]) {
    return this.validateBySchema(payload, this.updateUsersSchema)
  }

  async validateUpdateTaxesPayload(payload: ServiceUpdateUserDto[]) {
    return this.validateBySchema(payload, this.updateTaxesSchema)
  }
}
