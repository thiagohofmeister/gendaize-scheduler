import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class ScheduledController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
    this.get = this.get.bind(this)
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Scheduled').create(req.body),
      ResponseTypeEnum.CREATED
    )
  }

  async get(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Scheduled').get(req.query),
      ResponseTypeEnum.OK
    )
  }
}
