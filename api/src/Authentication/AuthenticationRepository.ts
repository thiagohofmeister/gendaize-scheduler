import { SelectQueryBuilder } from 'typeorm'
import { OrganizationDao } from '../Organization/Models/OrganizationDao'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Authentication } from './Models/Authentication'
import { AuthenticationDao } from './Models/AuthenticationDao'

export class AuthenticationRepository extends TypeOrmMysqlRepositoryContract<
  Authentication,
  AuthenticationDao
> {
  getRepository() {
    return this.getManager().getRepository(AuthenticationDao)
  }
}
