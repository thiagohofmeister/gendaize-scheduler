import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { SuccessContract } from './SuccessContract'

export class NoContentResponse extends SuccessContract {
  getStatus(): number {
    return ResponseTypeEnum.NO_CONTENT
  }
}
