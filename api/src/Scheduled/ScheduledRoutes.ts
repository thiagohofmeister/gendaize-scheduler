import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { ScheduledController } from './ScheduledController'

export class ScheduledRoutes extends BaseRoute<ScheduledController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [new AuthRouteDto(this.getFullEndpoint(), HttpMethodEnum.POST, controller.post)]
  }
}
