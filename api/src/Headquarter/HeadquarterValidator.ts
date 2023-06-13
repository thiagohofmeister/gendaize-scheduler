import * as Joi from 'joi'
import { Schema } from 'joi'
import { BaseValidator } from '../Base/BaseValidator'
import { HeadquarterCreateDto } from './Dto/HeadquarterCreateDto'
import { HeadquarterUpdateLocationDto } from './Dto/HeadquarterUpdateLocationDto'

export class HeadquarterValidator extends BaseValidator {
  private readonly createSchema: Schema

  private readonly updateLocationsSchema: Schema

  constructor() {
    super()

    this.updateLocationsSchema = Joi.array().items(
      Joi.object({
        id: Joi.string().required()
      })
    )

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
      schedules: Joi.array()
        .items(
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
        .allow(null),
      locations: this.updateLocationsSchema.optional().allow(null)
    })
  }

  public async validateCreatePayload(payload: HeadquarterCreateDto) {
    return this.validateBySchema(payload, this.createSchema)
  }

  public async validateUpdateLocationsPayload(payload: HeadquarterUpdateLocationDto[]) {
    return this.validateBySchema(payload, this.updateLocationsSchema)
  }
}
