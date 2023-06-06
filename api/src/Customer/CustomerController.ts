import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'
import { Controller } from '../Shared/Utils/DecoratorUtils'

@Controller
export class CustomerController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req)
        .buildService('Customer')
        .create(req.context?.organization, req.body),
      ResponseTypeEnum.CREATED
    )
  }
}
