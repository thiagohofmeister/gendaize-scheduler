import { BaseRoute } from '../Base/BaseRoute'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { AuthenticationController } from './AuthenticationController'

export class AuthenticationRoutes extends BaseRoute<AuthenticationController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [new RouteDto(this.getFullEndpoint(), HttpMethodEnum.POST, controller.post)]
  }
}
