import { EntityManager, FindOptionsWhere, ObjectID, SelectQueryBuilder } from 'typeorm'

import { DaoModel } from '../Shared/Models/DaoModel'
import { DomainModel } from '../Shared/Models/DomainModel'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { IRepository } from '../Shared/Models/Interfaces/IRepository'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'

export abstract class BaseRepository<TDomainEntity extends DomainModel, TDaoEntity extends DaoModel>
  implements IRepository<TDomainEntity>
{
  constructor(private manager: EntityManager) {}

  abstract delete(
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
  ): Promise<boolean>

  abstract save(entity: TDomainEntity, withFindBeforeReturn: boolean): Promise<TDomainEntity>

  abstract create(entity: TDomainEntity): Promise<TDomainEntity>

  abstract findOneByPrimaryColumn(id: string): Promise<TDomainEntity>

  abstract findAll(filter: FilterDefault): Promise<ListResponseModel<TDomainEntity>>

  protected abstract getOne(query: SelectQueryBuilder<TDaoEntity>): Promise<TDomainEntity | null>

  protected abstract getMany(
    query: SelectQueryBuilder<TDaoEntity>
  ): Promise<ListResponseModel<TDomainEntity>>

  public setManager(manager: EntityManager) {
    this.manager = manager
    return this
  }

  public getManager(): EntityManager {
    return this.manager
  }

  abstract getRepository()
}
