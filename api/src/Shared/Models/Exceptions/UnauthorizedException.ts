import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { BaseError } from './BaseError'

export class UnauthorizedException extends BaseError {
  constructor(message: string = 'Unauthorized.') {
    super(message)
  }

  getHttpStatusCode(): ResponseTypeEnum {
    return ResponseTypeEnum.UNAUTHORIZED
  }
}
