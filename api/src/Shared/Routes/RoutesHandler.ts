import { Router } from 'express'

import { AuthMiddleware } from '../../Authentication/Middlewares/AuthMiddleware'
import { BaseAuthRoute } from '../../Base/BaseAuthRoute'
import { BaseRoute } from '../../Base/BaseRoute'
import { PathUtils } from '../Utils/PathUtils'

export class RoutesHandler {
  private authRoutes: BaseAuthRoute<any>[]
  private noAuthRoutes: BaseRoute<any>[]

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

      if (route instanceof BaseAuthRoute) {
        this.authRoutes.push(route)
        return
      }

      this.noAuthRoutes.push(route)
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
      const routes = route.getRoutes()

      for (let j = 0; j < routes.length; j++) {
        const route = routes[j]
        router[route.getMethod()](route.getPath(), route.getHandle())
      }
    }

    this.getAuthMiddlewares().forEach(middleware => router.use(middleware))

    for (let i = 0; i < this.authRoutes.length; i++) {
      const route = this.authRoutes[i]
      const routes = route.getRoutes()

      for (let j = 0; j < routes.length; j++) {
        const route = routes[j]
        router[route.getMethod()](route.getPath(), route.getHandle())
      }
    }

    return router
  }
}
