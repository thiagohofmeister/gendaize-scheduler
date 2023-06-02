import { SelectQueryBuilder } from 'typeorm'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { EncryptUtils } from '../Shared/Utils/EncryptUtils'
import { User } from './Models/User'
import { UserDao } from './Models/UserDao'

export class UserRepository extends TypeOrmMysqlRepositoryContract<User, UserDao> {
  protected async beforeSave(entity: User): Promise<void> {
    entity.setPassword(entity.getPassword())
  }

  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<UserDao>
  ): SelectQueryBuilder<UserDao> {
    return query.innerJoin('UserDao.userOrganizations', 'organizations')
  }

  async findOneByAuthData(login: string, password: string): Promise<User> {
    const query = this.getRepository()
      .createQueryBuilder()
      .innerJoinAndSelect('UserDao.userOrganizations', 'userOrganizations')
      .innerJoinAndSelect('userOrganizations.organization', 'organization')
      .where('(UserDao.email = :login or UserDao.document_number = :login)', { login })
      .andWhere('UserDao.password = :password', {
        password: EncryptUtils.password(password)
      })

    return this.getOne(query)
  }

  async findOneByDocumentNumber(documentNumber: string): Promise<User> {
    return this.getOne({ where: { documentNumber } })
  }

  getRepository() {
    return this.getManager().getRepository(UserDao)
  }
}
