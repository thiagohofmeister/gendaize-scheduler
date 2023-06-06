import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { ServiceCreateDto } from './Dto/ServiceCreateDto'
import { ServiceUpdateUserDto } from './Dto/ServiceUpdateUserDto'
import { ServiceTypeEnum } from './Enums/ServiceTypeEnum'

export class ServiceValidator extends BaseValidator {
  private createSchema: Schema
  private updateUsersSchema: Schema

  constructor() {
    super()

    this.createSchema = Joi.object({
      name: Joi.string().required(),
      price: Joi.number().required(),
      type: Joi.valid(...Object.keys(ServiceTypeEnum)).required(),
      sameTimeQuantity: Joi.number().required()
    })

    this.updateUsersSchema = Joi.array().items(
      Joi.object({
        id: Joi.string().required()
      })
    )
  }

  async validateCreatePayload(payload: ServiceCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }

  async validateUpdateUsersPayload(payload: ServiceUpdateUserDto[]) {
    return this.validateBySchema(payload, this.updateUsersSchema)
  }
}
