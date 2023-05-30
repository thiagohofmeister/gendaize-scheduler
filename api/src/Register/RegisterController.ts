import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class RegisterController extends BaseController {
  constructor() {
    super()
    this.post = this.post.bind(this)
  }

  public async post(req: CoreRequest, res: Response, next: NextFunction) {
    await this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req)).buildRegisterService().create(req.body),
      ResponseTypeEnum.CREATED
    )
  }
}
