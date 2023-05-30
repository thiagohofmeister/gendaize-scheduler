import { BaseAuthRoute } from '../Base/BaseAuthRoute'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { UserController } from './UserController'

export class UserRoutes extends BaseAuthRoute<UserController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [new RouteDto(this.getFullEndpoint('/me'), HttpMethodEnum.GET, controller.getLogged)]
  }
}
