import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class UserController extends BaseController {
  constructor() {
    super()
    this.get = this.get.bind(this)
    this.getLogged = this.getLogged.bind(this)
  }

  async get(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req)).buildService('User').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  async getLogged(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req)).buildService('User').getById(req.context?.user?.id),
      ResponseTypeEnum.OK
    )
  }
}
