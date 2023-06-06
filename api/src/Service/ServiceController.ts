import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class ServiceController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
    this.get = this.get.bind(this)
    this.putUsers = this.putUsers.bind(this)
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req)
        .buildService('Service')
        .create(req.context?.organization, req.body),
      ResponseTypeEnum.CREATED
    )
  }

  async get(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Service').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  async putUsers(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Service').updateUsers(req.params.id, req.body),
      ResponseTypeEnum.OK
    )
  }
}
