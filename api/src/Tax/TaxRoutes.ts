import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { TaxController } from './TaxController'

export class TaxRoutes extends BaseRoute<TaxController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [
      new AuthRouteDto(this.getFullEndpoint(), HttpMethodEnum.POST, controller.post),
      new AuthRouteDto(this.getFullEndpoint(), HttpMethodEnum.GET, controller.get)
    ]
  }
}
