import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { BaseError } from './BaseError'

export class InvalidDataException extends BaseError {
  getHttpStatusCode(): ResponseTypeEnum {
    return ResponseTypeEnum.INVALID_DATA
  }
}
