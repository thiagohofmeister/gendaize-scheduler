import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class HeadquarterController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req)
        .buildService('Headquarter')
        .create(req.context?.organization, req.body),
      ResponseTypeEnum.CREATED
    )
  }
}
