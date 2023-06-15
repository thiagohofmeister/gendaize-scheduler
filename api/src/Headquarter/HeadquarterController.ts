import { NextFunction, Response } from 'express'
import { BaseController } from '../Base/BaseController'
import { ResponseTypeEnum } from '../Base/Enums/ResponseTypeEnum'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'

export class HeadquarterController extends BaseController {
  constructor() {
    super()

    this.post = this.post.bind(this)
    this.get = this.get.bind(this)
    this.putLocations = this.putLocations.bind(this)
    this.getOneById = this.getOneById.bind(this)
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

  async get(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Headquarter').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  async getOneById(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Headquarter').getOneById(req.params.id),
      ResponseTypeEnum.OK
    )
  }

  async putLocations(req: CoreRequest, res: Response, next: NextFunction) {
    return this.responseHandler(
      res,
      next,
      this.getServiceFactory(req)
        .buildService('Headquarter')
        .updateLocations(req.params.id, req.body),
      ResponseTypeEnum.OK
    )
  }
}
