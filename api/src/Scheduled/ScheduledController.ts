import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class ScheduledController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
    this.get = this.get.bind(this)
    this.delete = this.delete.bind(this)
    this.postCalculateAmount = this.postCalculateAmount.bind(this)
  }

  async delete(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Scheduled').delete(req.params.id),
      ResponseTypeEnum.NO_CONTENT
    )
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
    console.log('ACESSOU O GET')
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Scheduled').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  async postCalculateAmount(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Scheduled').createCalculateAmount(req.body),
      ResponseTypeEnum.CREATED
    )
  }
}
