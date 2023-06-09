import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { ScheduledCreateCalculateAmountDto } from './Dto/ScheduledCreateCalculateAmountDto'
import { ScheduledCreateDto } from './Dto/ScheduledCreateDto'

export class ScheduledValidator extends BaseValidator {
  private createSchema: Schema
  private createCalculatePriceSchema: Schema

  constructor() {
    super()

    this.createSchema = Joi.object({
      startAt: Joi.date().required(),
      customerAddressesId: Joi.object({
        start: Joi.string().required(),
        end: Joi.string()
      }).required(),
      userId: Joi.string().required(),
      customerId: Joi.string().required(),
      serviceId: Joi.string().required(),
      headquarterId: Joi.string().required()
    })

    this.createCalculatePriceSchema = Joi.object({
      customerAddressesId: Joi.object({
        start: Joi.string().required(),
        end: Joi.string()
      }).required(),
      customerId: Joi.string().required(),
      services: Joi.array()
        .items(
          Joi.object({
            id: Joi.string().required()
          })
        )
        .required(),
      headquarterId: Joi.string().required()
    })
  }

  async validateCreatePayload(payload: ScheduledCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }

  async validateCreateCalculatePricePayload(payload: ScheduledCreateCalculateAmountDto) {
    return this.validateBySchema(payload, this.createCalculatePriceSchema)
  }
}
