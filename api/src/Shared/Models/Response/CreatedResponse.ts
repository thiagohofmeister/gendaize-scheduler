import { ResponseTypeEnum } from '../../../Base/Enums/ResponseTypeEnum'
import { SuccessContract } from './SuccessContract'

export class CreatedResponse extends SuccessContract {
  getStatus(): number {
    return ResponseTypeEnum.CREATED
  }
}
