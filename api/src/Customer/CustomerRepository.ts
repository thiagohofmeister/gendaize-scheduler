import { SelectQueryBuilder } from 'typeorm'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { EncryptUtils } from '../Shared/Utils/EncryptUtils'
import { Customer } from './Models/Customer'
import { CustomerDao } from './Models/CustomerDao'

export class CustomerRepository extends TypeOrmMysqlRepositoryContract<Customer, CustomerDao> {
  protected async beforeSave(entity: Customer): Promise<void> {
    entity.setPassword(entity.getPassword())
  }

  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<CustomerDao>
  ): SelectQueryBuilder<CustomerDao> {
    return query.leftJoinAndSelect('CustomerDao.addresses', 'addresses')
  }

  async findOneByAuthData(login: string, password: string): Promise<Customer> {
    const query = this.getRepository()
      .createQueryBuilder()
      .innerJoinAndSelect('CustomerDao.organization', 'organization')
      .where('(CustomerDao.email = :login or CustomerDao.phone = :login)')
      .andWhere('CustomerDao.password = :password')
      .setParameters({ login, password: EncryptUtils.password(password) })

    return this.getOne(query)
  }

  getRepository() {
    return this.getManager().getRepository(CustomerDao)
  }
}
