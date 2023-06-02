import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { BaseError } from './BaseError'

export class BadRequestException extends BaseError {
  constructor(message: string = 'Bad request.') {
    super(message)
  }

  getHttpStatusCode(): ResponseTypeEnum {
    return ResponseTypeEnum.BAD_REQUEST
  }
}
