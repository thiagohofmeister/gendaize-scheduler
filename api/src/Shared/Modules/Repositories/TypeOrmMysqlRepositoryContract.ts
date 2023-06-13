import {
  EntityManager,
  FindOneOptions,
  FindOptionsWhere,
  ObjectID,
  SelectQueryBuilder
} from 'typeorm'
import { QueryDeepPartialEntity } from 'typeorm/query-builder/QueryPartialEntity'

import { BaseRepository } from '../../../Base/BaseRepository'
import { DaoModel } from '../../Models/DaoModel'
import { DomainModel } from '../../Models/DomainModel'
import { FilterDefault } from '../../Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../../Models/Interfaces/ListResponseModel'

export abstract class TypeOrmMysqlRepositoryContract<
  TDomainEntity extends DomainModel,
  TDaoEntity extends DaoModel
> extends BaseRepository<TDomainEntity, TDaoEntity> {
  constructor(manager: EntityManager, protected organizationId: string | null) {
    super(manager)
  }

  public async create(entity: TDomainEntity): Promise<TDomainEntity> {
    await this.beforeSave(entity)

    const result = await this.getRepository().insert(
      this.toDaoEntity(entity) as QueryDeepPartialEntity<TDaoEntity>
    )

    return this.findOneByPrimaryColumn(result.identifiers[0][this.getPrimaryColumnName()])
  }

  public async save(
    entity: TDomainEntity,
    withFindBeforeReturn: boolean = true
  ): Promise<TDomainEntity> {
    await this.beforeSave(entity)

    await this.getRepository().save(this.getRepository().create(this.toDaoEntity(entity)))

    if (!withFindBeforeReturn) return entity

    return this.findOneByPrimaryColumn(this.getPrimaryColumnValueByEntity(entity))
  }

  protected async beforeSave(entity: TDomainEntity) {}

  public async delete(
    criteria:
      | string
      | string[]
      | number
      | number[]
      | Date
      | Date[]
      | ObjectID
      | ObjectID[]
      | FindOptionsWhere<TDaoEntity>
  ): Promise<boolean> {
    await this.getRepository().delete(criteria)

    return true
  }

  public async findAll<TFilter extends FilterDefault>(
    filter: TFilter,
    bypassorganizationId: boolean = false,
    withoutPaginators: boolean = false
  ): Promise<ListResponseModel<TDomainEntity>> {
    let query = this.customToFindAll(this.getRepository().createQueryBuilder(), filter)

    if (!withoutPaginators) {
      query = this.applyPaginator(filter, query)
    }

    if (this.hasColumn('organizationId') && !bypassorganizationId) {
      query.andWhere(`${this.getTableName()}.organization_id = :organizationId`, {
        organizationId: this.organizationId
      })
    } else if (this.hasColumn('headquarter') && !bypassorganizationId) {
      if (!this.hasRelation('headquarter')) {
        query.leftJoin(`${this.getTableName()}.headquarter`, 'headquarter')
      }

      query.andWhere(`headquarter.organization_id = :organizationId`, {
        organizationId: this.organizationId
      })
    }

    return this.getMany(query)
  }

  public async findOneByPrimaryColumn(
    value: string,
    bypassorganizationId: boolean = false
  ): Promise<TDomainEntity> {
    const query = this.customToFindOneByPrimaryColumn(
      this.getRepository()
        .createQueryBuilder()
        .where(`${this.getTableName()}.${this.getPrimaryColumnName()} = :value`, { value })
    )

    if (this.hasColumn('organizationId') && !bypassorganizationId) {
      query.andWhere(`${this.getTableName()}.organization_id = :organizationId`, {
        organizationId: this.organizationId
      })
    } else if (this.hasColumn('headquarter') && !bypassorganizationId) {
      if (!this.hasRelation('headquarter')) {
        query.leftJoin(`${this.getTableName()}.headquarter`, 'headquarter')
      }

      query.andWhere(`headquarter.organization_id = :organizationId`, {
        organizationId: this.organizationId
      })
    }

    return this.getOne(query)
  }

  public applyPaginator(
    filter: FilterDefault,
    query: SelectQueryBuilder<TDaoEntity>
  ): SelectQueryBuilder<TDaoEntity> {
    return query.skip((this.getPage(filter) - 1) * this.getSize(filter)).take(this.getSize(filter))
  }

  protected getPage(filter: FilterDefault) {
    filter.page = typeof filter.page === 'string' ? parseInt(filter.page) : filter.page

    let page = 1
    if (filter.page > 0) {
      page = typeof filter.page === 'string' ? parseInt(filter.page) : filter.page
    }

    return page
  }

  protected getSize(filter: FilterDefault) {
    filter.size = typeof filter.size === 'string' ? parseInt(filter.size) : filter.size

    let size = 15
    if (filter.size > 0) {
      size = filter.size
      if (filter.size > 100) {
        size = 100
      }
    }

    return size
  }

  protected customToFindAll(
    query: SelectQueryBuilder<TDaoEntity>,
    filter?: FilterDefault
  ): SelectQueryBuilder<TDaoEntity> {
    return query
  }

  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<TDaoEntity>
  ): SelectQueryBuilder<TDaoEntity> {
    return query
  }

  protected hasColumn(columnName: string): boolean {
    return this.getRepository()
      .metadata.columns.map(column => column.propertyName)
      .includes(columnName)
  }

  protected hasRelation(propertyName: string): boolean {
    return this.getRepository()
      .metadata.relations.map(relation => relation.propertyName)
      .includes(propertyName)
  }

  protected getTableName(): string {
    return this.getRepository().metadata.targetName
  }

  protected getPrimaryColumnName(): string {
    return this.getRepository().metadata.primaryColumns[0].propertyAliasName
  }

  protected getPrimaryColumnValueByEntity(entity: TDomainEntity): string {
    return entity[this.getPrimaryColumnName()]
  }

  protected async getOne(
    query: SelectQueryBuilder<TDaoEntity> | FindOneOptions<TDaoEntity>
  ): Promise<TDomainEntity> {
    let entity: TDaoEntity

    if (query instanceof SelectQueryBuilder) {
      entity = await query.getOne()
    } else {
      entity = await this.getRepository().findOne(query)
    }

    if (!entity) return null

    return this.toDomainEntity(entity)
  }

  protected async getMany(
    query: SelectQueryBuilder<TDaoEntity> | FindOneOptions<TDaoEntity>
  ): Promise<ListResponseModel<TDomainEntity>> {
    if (query instanceof SelectQueryBuilder) {
      return {
        items: this.toDomainEntityMany(await query.getMany()),
        total: await query.getCount()
      }
    }

    return {
      items: this.toDomainEntityMany(await this.getRepository().find(query)),
      total: await this.getRepository().count(query)
    }
  }

  protected toDomainEntity(entity: TDaoEntity): TDomainEntity {
    return entity.toDomain()
  }

  protected toDomainEntityMany(entities: TDaoEntity[]): TDomainEntity[] {
    return entities.map(entity => this.toDomainEntity(entity))
  }

  protected toDaoEntity(entity: TDomainEntity) {
    return entity.toDao()
  }
}
