import { EntityManager, FindManyOptions, MongoRepository, ObjectLiteral } from 'typeorm'
import { QueryDeepPartialEntity } from 'typeorm/query-builder/QueryPartialEntity'
import { BaseRepository } from '../../../Base/BaseRepository'
import { DaoModel } from '../../Models/DaoModel'
import { DomainModel } from '../../Models/DomainModel'
import { FilterDefault } from '../../Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../../Models/Interfaces/ListResponseModel'

export abstract class TypeOrmMongoDBRepositoryContract<
  TDomainEntity extends DomainModel,
  TDaoEntity extends DaoModel
> extends BaseRepository<TDomainEntity, null> {
  public constructor(
    manager: EntityManager,
    protected readonly repository: MongoRepository<TDaoEntity>
  ) {
    super(manager)
    this.repository = repository
  }

  public async getAll(filters: FilterDefault): Promise<ListResponseModel<TDomainEntity>> {
    const query = this.applyPaginator(
      filters,
      this.applySearch(filters, this.customToGetAll(filters, {}))
    )

    return {
      total: await this.repository.count(query.where as ObjectLiteral),
      items: (await this.repository.find(query)).map(e => this.getDomainEntityByDaoEntity(e))
    }
  }

  public async create(entity: TDomainEntity): Promise<TDomainEntity> {
    try {
      const result = await this.repository.save(
        this.repository.create(this.getDaoEntityByDomainEntity(entity))
      )

      return this.getDomainEntityByDaoEntity(result)
    } catch (e) {
      console.error({ e })
      return null
    }
  }

  public async save(entity: TDomainEntity): Promise<TDomainEntity> {
    try {
      const entityToSave = this.repository.create(this.getDaoEntityByDomainEntity(entity))

      const result = await this.repository.save(entityToSave)

      return this.getDomainEntityByDaoEntity(result)
    } catch (e) {
      return null
    }
  }

  public async createOrUpdate(entity: TDomainEntity, conditions?: {} | string): Promise<void> {
    const result = await this.create(entity)

    if (!result) {
      await this.update(entity, conditions)
    }
  }

  public async delete(id: string): Promise<boolean> {
    try {
      await this.repository.delete(id)

      return true
    } catch (e) {
      return false
    }
  }

  public async update(entity: TDomainEntity, conditions?: {} | string): Promise<boolean> {
    try {
      const result = await this.repository.update(
        conditions,
        entity.toDao() as QueryDeepPartialEntity<TDaoEntity>
      )

      return !!result.affected
    } catch (e) {
      return false
    }
  }

  public applyPaginator(
    filters: FilterDefault,
    query: FindManyOptions<TDaoEntity>
  ): FindManyOptions<TDaoEntity> {
    const skip = (this.getPage(filters) - 1) * this.getSize(filters)
    const take = this.getSize(filters)

    query = {
      ...query,
      skip,
      take
    }

    return query
  }

  protected customToGetAll(
    filters: FilterDefault,
    query: FindManyOptions<TDaoEntity>
  ): FindManyOptions<TDaoEntity> {
    return query
  }

  protected applySearch(
    filters: FilterDefault,
    query: FindManyOptions<TDaoEntity>
  ): FindManyOptions<TDaoEntity> {
    if (!filters.query) {
      return query
    }

    const fieldsToWhere = []
    for (const field of this.getFieldsToSearch(filters)) {
      const nameReg = new RegExp(filters.query, 'i')
      fieldsToWhere.push({ [field]: { $regex: nameReg } })
    }

    if (fieldsToWhere.length) {
      query.where['$or'] = fieldsToWhere
    }

    return query
  }

  protected getFieldsToSearch(filters: FilterDefault): string[] {
    return []
  }

  protected getPage(filters: FilterDefault) {
    filters.page = typeof filters.page === 'string' ? parseInt(filters.page) : filters.page

    let page = 1
    if (filters.page > 0) {
      page = typeof filters.page === 'string' ? parseInt(filters.page) : filters.page
    }

    return page
  }

  protected getSize(filters: FilterDefault) {
    filters.size = typeof filters.size === 'string' ? parseInt(filters.size) : filters.size

    let size = 15
    if (filters.size > 0) {
      size = filters.size
      if (filters.size > 100) {
        size = 100
      }
    }

    return size
  }

  public async findAll(filters: FilterDefault): Promise<ListResponseModel<TDomainEntity>> {
    const query = this.applySearch(filters, this.customToGetAll(filters, {}))

    return {
      items: (await this.repository.find(query)).map(e => this.getDomainEntityByDaoEntity(e)),
      total: await this.repository.count(query)
    }
  }

  protected getDaoEntityByDomainEntity(domain: TDomainEntity): TDaoEntity {
    return domain.toDao()
  }

  protected getDomainEntityByDaoEntity(entity: TDaoEntity): TDomainEntity {
    return entity.toDomain()
  }
}
