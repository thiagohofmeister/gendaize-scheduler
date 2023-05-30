import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { SuccessContract } from './SuccessContract'

export class AcceptedResponse extends SuccessContract {
  getStatus(): number {
    return ResponseTypeEnum.ACCEPTED
  }
}
