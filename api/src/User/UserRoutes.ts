import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { UserController } from './UserController'

export class UserRoutes extends BaseRoute<UserController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [new AuthRouteDto(this.getFullEndpoint('/me'), HttpMethodEnum.GET, controller.getLogged)]
  }
}
