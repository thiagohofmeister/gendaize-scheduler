import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class UserController extends BaseController {
  constructor() {
    super()
    this.getLogged = this.getLogged.bind(this)
  }

  async getLogged(request: CoreRequest, response: Response, next: NextFunction) {
    return this.responseHandler(
      response,
      next,
      (await this.getServiceFactory(request))
        .buildService('User')
        .getById(request.context?.user?.id),
      ResponseTypeEnum.OK
    )
  }
}
