import { DataSource } from 'typeorm'

import { PathUtils } from '../Utils/PathUtils'

export class RepositoryFactory {
  constructor(private readonly dataSource: DataSource, private readonly organizationId: string) {}

  public buildRepository(domainName: string) {
    const Repository = PathUtils.getRepository(domainName)

    return new Repository(this.dataSource, this.organizationId)
  }

  public getDataSource(): DataSource {
    return this.dataSource
  }
}
