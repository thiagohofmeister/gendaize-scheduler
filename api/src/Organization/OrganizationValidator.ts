import * as Joi from 'joi'
import { Schema } from 'joi'

import { BaseValidator } from '../Base/BaseValidator'
import { OrganizationCreateDto } from './Dto/OrganizationCreateDto'

export class OrganizationValidator extends BaseValidator {
  private organizationCreateSchema: Schema

  constructor() {
    super()

    this.organizationCreateSchema = Joi.object({
      name: Joi.string().required(),
      document: Joi.object({
        type: Joi.string().required(),
        number: Joi.string().required(),
        name: Joi.string().required()
      }).required(),
      email: Joi.string().required(),
      phone: Joi.string().required()
    })
  }

  public async organizationCreatePayloadValidate(payload: OrganizationCreateDto) {
    return this.validateBySchema<OrganizationCreateDto>(payload, this.organizationCreateSchema)
  }
}
