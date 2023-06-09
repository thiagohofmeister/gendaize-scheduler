import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { LocationController } from './LocationController'

export class LocationRoutes extends BaseRoute<LocationController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [
      new AuthRouteDto(this.getFullEndpoint(), HttpMethodEnum.GET, controller.get),
      new AuthRouteDto(
        this.getFullEndpoint('address'),
        HttpMethodEnum.POST,
        controller.getLocationByAddress
      )
    ]
  }
}
