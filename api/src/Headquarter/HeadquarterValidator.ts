import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { HeadquarterCreateDto } from './Dto/HeadquarterCreateDto'

export class HeadquarterValidator extends BaseValidator {
  private readonly createSchema: Schema

  constructor() {
    super()

    this.createSchema = Joi.object({
      name: Joi.string().required(),
      address: Joi.object({
        state: Joi.string().required(),
        city: Joi.string().required(),
        district: Joi.string().required(),
        street: Joi.string().required(),
        number: Joi.string().required(),
        complement: Joi.string().allow(null),
        zipCode: Joi.string().required()
      }).required(),
      schedules: Joi.array().items(
        Joi.object({
          day: Joi.number().required(),
          schedules: Joi.array().items(
            Joi.object({
              start: Joi.number().required(),
              end: Joi.number().required()
            })
          )
        })
      )
    })
  }

  public async validateCreatePayload(payload: HeadquarterCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }
}
