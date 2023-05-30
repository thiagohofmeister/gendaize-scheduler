import { FilterDefault } from './FilterDefault'
import { ListResponseModel } from './ListResponseModel'

export interface IRepository<TDomainEntity> {
  save(entity: TDomainEntity, withFindBeforeReturn?: boolean): Promise<TDomainEntity>
  create(entity: TDomainEntity): Promise<TDomainEntity>
  findOneByPrimaryColumn(value: string): Promise<TDomainEntity>
  findAll(filter: FilterDefault): Promise<ListResponseModel<TDomainEntity>>
  delete(criteria: any): Promise<boolean>
}
