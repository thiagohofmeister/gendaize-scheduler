import { kebabCase } from 'lodash'

import { BaseController } from './BaseController'
import { RouteDto } from './Dto/RouteDto'

export abstract class BaseRoute<T extends BaseController> {
  protected readonly basePath: string

  constructor(protected readonly controller: T) {
    this.basePath = kebabCase(this.constructor.name.replace('Routes', ''))
  }

  protected getController() {
    return this.controller
  }

  protected getFullEndpoint(route: string = '') {
    return `/${[this.basePath, route].filter(r => !!r.trim()).join('/')}`.replace(/\/\//, '/')
  }

  abstract getRoutes(): RouteDto[]
}
