import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class OrganizationController extends BaseController {
  constructor() {
    super()
    this.post = this.post.bind(this)
    this.getLocations = this.getLocations.bind(this)
  }

  async post(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req)).buildService('Organization').create(req.body),
      ResponseTypeEnum.CREATED
    )
  }

  async getLocations(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      (await this.getServiceFactory(req))
        .buildService('Organization')
        .getLocations(req.context?.organizationId),
      ResponseTypeEnum.OK
    )
  }
}
