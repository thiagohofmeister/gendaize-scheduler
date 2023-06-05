import { Postgres } from '../../Database/Postgres'
import { PathUtils } from '../Utils/PathUtils'
import { ProviderFactory } from './ProviderFactory'
import { RepositoryFactory } from './RepositoryFactory'
import { ServiceFactory } from './ServiceFactory'

export class Factory {
  private static instance: Factory

  private constructor() {}

  public buildProviderFactory() {
    return new ProviderFactory()
  }

  public buildRepositoryFactory(organizationId: string) {
    return new RepositoryFactory(Postgres.getDataSource(), organizationId)
  }

  public buildServiceFactory(organizationId: string) {
    return new ServiceFactory(
      this.buildRepositoryFactory(organizationId),
      this.buildProviderFactory()
    )
  }

  public buildService(domainName: string) {
    const Service = require(PathUtils.getPathes()[domainName]['service'])[`${domainName}Service`]

    return new Service()
  }

  public static getInstance() {
    if (!this.instance) {
      this.instance = new Factory()
    }

    return this.instance
  }
}
