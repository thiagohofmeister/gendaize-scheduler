import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { BaseError } from './BaseError'

export class NotFoundException extends BaseError {
  constructor(message: string = 'Not found.') {
    super(message)
  }

  getHttpStatusCode(): ResponseTypeEnum {
    return ResponseTypeEnum.NOT_FOUND
  }
}
