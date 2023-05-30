import { NextFunction, Request, Response } from 'express'
import { ResponseTypeEnum } from '../../Base/Enums/ResponseTypeEnum'
import { BaseError } from '../Models/Exceptions/BaseError'
import { DataNotFoundException } from '../Models/Exceptions/DataNotFoundException'

export class ErrorHandler {
  constructor() {
    this.notFound = this.notFound.bind(this)
    this.error = this.error.bind(this)
    this.getResponseBody = this.getResponseBody.bind(this)
    this.getHttpStatusCode = this.getHttpStatusCode.bind(this)
  }

  public notFound(request: Request, response: Response, next: NextFunction) {
    return this.error(
      new DataNotFoundException('Resource not found.').setCode('resourceNotFound'),
      request,
      response,
      next
    )
  }

  public error(error: Error, request: Request, response: Response, next: NextFunction) {
    let httpStatusCode = this.getHttpStatusCode(error)

    if (httpStatusCode === 500) {
      console.error(error)
    }

    response.status(httpStatusCode).json(this.getResponseBody(error, httpStatusCode))
  }

  private getResponseBody(error: Error, httpStatusCode: number) {
    if (error instanceof BaseError) {
      return {
        message: error.message,
        code: `${httpStatusCode}.${error.getCode()}`,
        reasons: error.getReasons()
      }
    }

    return {
      code: `${httpStatusCode}.internalServerError`,
      message: error.message,
      reasons: []
    }
  }

  private getHttpStatusCode(error: Error): ResponseTypeEnum {
    if (error instanceof BaseError) {
      return error.getHttpStatusCode()
    }

    return ResponseTypeEnum.INTERNAL_SERVER_ERROR
  }
}
