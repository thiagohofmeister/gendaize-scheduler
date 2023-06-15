import { NextFunction, Response } from 'express'

import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class LocationController extends BaseController {
  constructor() {
    super()
    this.getOneByLocation = this.getOneByLocation.bind(this)
    this.postDistance = this.postDistance.bind(this)
    this.get = this.get.bind(this)
    this.getLocationByAddress = this.getLocationByAddress.bind(this)
  }

  public async get(req: CoreRequest, res: Response, next: NextFunction) {
    await this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Location').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  public async getLocationByAddress(req: CoreRequest, res: Response, next: NextFunction) {
    await this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Location').findLocationByAddress(req.body),
      ResponseTypeEnum.OK
    )
  }

  public async getOneByLocation(req: CoreRequest, res: Response, next: NextFunction) {
    await this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Location').findOneByZipCode(req.params.zipCode),
      ResponseTypeEnum.OK
    )
  }

  public async postDistance(req: CoreRequest, res: Response, next: NextFunction) {
    await this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Location').calculateDistances(req.body),
      ResponseTypeEnum.OK
    )
  }
}
