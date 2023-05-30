import { BaseController } from './BaseController'
import { BaseRoute } from './BaseRoute'

export abstract class BaseAuthRoute<T extends BaseController> extends BaseRoute<T> {}
