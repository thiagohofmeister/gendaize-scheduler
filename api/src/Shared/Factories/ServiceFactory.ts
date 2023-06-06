import { PathUtils } from '../Utils/PathUtils'
import { ProviderFactory } from './ProviderFactory'
import { RepositoryFactory } from './RepositoryFactory'

export class ServiceFactory {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly providerFactory: ProviderFactory
  ) {}

  buildService(domainName: string): any {
    const Service = PathUtils.getService(domainName)

    return Reflect.construct(
      Service,
      Service.getReflect().map(item => {
        switch (item.name) {
          case 'DataSource':
            return this.repositoryFactory.getDataSource()

          case `${domainName}Repository`:
            return this.repositoryFactory.buildRepository(domainName)

          case `${domainName}Validator`:
            return Reflect.construct(PathUtils.getValidator(domainName), [])

          default:
            if (item.name.includes('Provider')) {
              return this.providerFactory[`build${item.name}`]()
            }

            if (item.name.includes('Service')) {
              return this.buildService(item.name.replace('Service', ''))
            }

            throw new Error(`Not implemented factory to: ${item.name}`)
        }
      })
    )
  }
}
