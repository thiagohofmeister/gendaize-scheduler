import { Router } from 'express'

import { AuthMiddleware } from '../../Authentication/Middlewares/AuthMiddleware'
import { AuthRouteDto } from '../../Base/Dto/AuthRouteDto'
import { RouteDto } from '../../Base/Dto/RouteDto'
import { PathUtils } from '../Utils/PathUtils'

export class RoutesHandler {
  private authRoutes: AuthRouteDto[]
  private noAuthRoutes: RouteDto[]

  constructor() {
    this.initializeRoutes = this.initializeRoutes.bind(this)
    this.getAuthMiddlewares = this.getAuthMiddlewares.bind(this)
    this.getDefaultMiddlewares = this.getDefaultMiddlewares.bind(this)
    this.getRouter = this.getRouter.bind(this)

    this.authRoutes = []
    this.noAuthRoutes = []

    this.initializeRoutes()
  }

  private initializeRoutes() {
    PathUtils.getDomains().forEach(domainName => {
      const Route = PathUtils.getRoute(domainName)

      const Controller = PathUtils.getController(domainName)

      if (!Route || !Controller) return

      const route = new Route(new Controller())

      const routes = route.getRoutes()

      for (let i = 0; i < routes.length; i++) {
        const endpoint = routes[i]
        if (endpoint instanceof AuthRouteDto) {
          this.authRoutes.push(routes[i])
          continue
        }

        this.noAuthRoutes.push(routes[i])
      }
    })
  }

  private getAuthMiddlewares() {
    return [new AuthMiddleware().forAll]
  }

  private getDefaultMiddlewares() {
    return []
  }

  public getRouter() {
    const router = Router()

    this.getDefaultMiddlewares().forEach(middleware => router.use(middleware))

    for (let i = 0; i < this.noAuthRoutes.length; i++) {
      const route = this.noAuthRoutes[i]

      router[route.getMethod()](route.getPath(), route.getHandle())
    }

    this.getAuthMiddlewares().forEach(middleware => router.use(middleware))

    for (let i = 0; i < this.authRoutes.length; i++) {
      const route = this.authRoutes[i]

      router[route.getMethod()](route.getPath(), route.getHandle())
    }

    return router
  }
}
