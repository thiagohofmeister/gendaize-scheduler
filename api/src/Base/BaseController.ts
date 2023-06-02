import { NextFunction, Response } from 'express'

import { Factory } from '../Shared/Factories/Factory'
import { CoreRequest } from '../Shared/Models/Request/CoreRequest'
import { AcceptedResponse } from '../Shared/Models/Response/AcceptedResponse'
import { CreatedResponse } from '../Shared/Models/Response/CreatedResponse'
import { NoContentResponse } from '../Shared/Models/Response/NoContentResponse'
import { OkResponse } from '../Shared/Models/Response/OkResponse'
import { SuccessContract } from '../Shared/Models/Response/SuccessContract'
import { ResponseModel } from '../Shared/Models/ResponseModel'
import { ResponseTypeEnum } from './Enums/ResponseTypeEnum'

export abstract class BaseController {
  constructor() {}

  protected async responseHandler(
    response: Response,
    next: NextFunction,
    promise: any,
    responseType: ResponseTypeEnum
  ): Promise<void> {
    try {
      const body: ResponseModel = await promise

      this.successResponseHandler(this.buildSuccessResponse(responseType, body), response)
    } catch (error) {
      next(error)
    }
  }

  private successResponseHandler(result: SuccessContract, response: Response) {
    response.status(result.getStatus())

    if (result instanceof NoContentResponse) {
      response.send()
      return
    }

    response.json(result.getBody())
  }

  private buildSuccessResponse(responseType: ResponseTypeEnum, body: any): SuccessContract {
    if (!body) {
      return new NoContentResponse()
    }

    switch (responseType) {
      case ResponseTypeEnum.OK:
        return new OkResponse(body)

      case ResponseTypeEnum.CREATED:
        return new CreatedResponse(body)

      case ResponseTypeEnum.ACCEPTED:
        return new AcceptedResponse(body)

      case ResponseTypeEnum.NO_CONTENT:
        return new NoContentResponse()

      default:
        throw new Error(`Response type ${responseType} is not implemented.`)
    }
  }

  protected getServiceFactory(request: CoreRequest) {
    return Factory.getInstance().buildServiceFactory(request.context?.organizationId)
  }
}
