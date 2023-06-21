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
    this.postAddress = this.postAddress.bind(this)
    this.get = this.get.bind(this)
    this.getOneById = this.getOneById.bind(this)
    this.delete = this.delete.bind(this)
    this.deleteAddress = this.deleteAddress.bind(this)
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

  async postAddress(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Customer').createAddress(req.params.id, req.body),
      ResponseTypeEnum.CREATED
    )
  }

  async deleteAddress(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req)
        .buildService('Customer')
        .deleteAddress(req.params.id, req.params.addressId),
      ResponseTypeEnum.OK
    )
  }

  async get(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Customer').get(req.query),
      ResponseTypeEnum.OK
    )
  }

  async getOneById(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Customer').getById(req.params.id),
      ResponseTypeEnum.OK
    )
  }

  async delete(req: CoreRequest, res: Response, next: NextFunction) {
    this.responseHandler(
      res,
      next,
      this.getServiceFactory(req).buildService('Customer').delete(req.params.id),
      ResponseTypeEnum.NO_CONTENT
    )
  }
}
