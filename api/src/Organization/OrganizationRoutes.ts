import { BaseRoute } from '../Base/BaseRoute'
import { AuthRouteDto } from '../Base/Dto/AuthRouteDto'
import { RouteDto } from '../Base/Dto/RouteDto'
import { HttpMethodEnum } from '../Base/Enums/HttpMethodEnum'
import { OrganizationController } from './OrganizationController'

export class OrganizationRoutes extends BaseRoute<OrganizationController> {
  getRoutes(): RouteDto[] {
    const controller = this.getController()

    return [
      new AuthRouteDto(
        this.getFullEndpoint('locations'),
        HttpMethodEnum.GET,
        controller.getLocations
      )
    ]
  }
}
