import { Schema } from 'joi'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'

export class BaseValidator {
  protected async validateBySchema<TBody>(body: TBody, schema: Schema) {
    try {
      await schema.validateAsync(body, { abortEarly: false })
    } catch (e) {
      throw new InvalidDataException(
        'Invalid data.',
        e.details.map(detail => ({
          id: `${detail.path.join('.')}.${detail.type}`,
          message: detail.message
        }))
      )
    }
  }
}
