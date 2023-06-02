import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { AuthenticationController } from './AuthenticationController'

export class AuthenticationRoutes extends BaseRoute<AuthenticationController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [
      new RouteDto(this.getFullEndpoint(), HttpMethodEnum.POST, controller.post),
      new AuthRouteDto(this.getFullEndpoint(), HttpMethodEnum.DELETE, controller.logout)
    ]
  }
}
