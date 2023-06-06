import { DataSource, EntityManager } from 'typeorm'

export abstract class BaseService {
  constructor(private readonly dataSource: DataSource) {}

  public async transactionalFn<T>(fn: (manager: EntityManager) => Promise<T>): Promise<T> {
    return await this.dataSource.transaction(async manager => fn(manager))
  }

  public static getReflect() {
    return Reflect.getMetadata('design:paramtypes', this)
  }
}
