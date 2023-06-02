import * as Joi from 'joi'
import { Schema } from 'joi'

import { BaseValidator } from '../Base/BaseValidator'
import { UserCreateDto } from './Dto/UserCreateDto'

export class UserValidator extends BaseValidator {
  private userCreateSchema: Schema

  constructor() {
    super()

    this.userCreateSchema = Joi.object({
      name: Joi.string().required(),
      documentNumber: Joi.string().required(),
      email: Joi.string().required(),
      password: Joi.string().required()
    })
  }

  public async userCreatePayloadValidate(payload: UserCreateDto) {
    return this.validateBySchema<UserCreateDto>(payload, this.userCreateSchema)
  }
}
