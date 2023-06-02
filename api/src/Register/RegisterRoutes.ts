import { BaseRoute } from '../Base/BaseRoute'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { RegisterController } from './RegisterController'

export class RegisterRoutes extends BaseRoute<RegisterController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [new RouteDto(this.getFullEndpoint(), HttpMethodEnum.POST, controller.post)]
  }
}
