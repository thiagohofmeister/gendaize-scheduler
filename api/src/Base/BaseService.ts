import { DataSource, EntityManager } from 'typeorm'

export abstract class BaseService {
  constructor(private readonly dataSource: DataSource) {}

  public async transactionalF<T>(fn: (manager: EntityManager) => Promise<T>): Promise<T> {
    return await this.dataSource.transaction(async manager => fn(manager))
  }
}
