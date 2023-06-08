import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { Scheduled } from './Models/Scheduled'
import { ScheduledDao } from './Models/ScheduledDao'

export class ScheduledRepository extends TypeOrmMysqlRepositoryContract<Scheduled, ScheduledDao> {
  getByStartAtAndEndAtAndUserId(startAt: Date, endAt: Date, userId: string) {
    return this.getRepository()
      .createQueryBuilder()
      .where(
        '((ScheduledDao.start_at <= :startAt AND ScheduledDao.end_at >= :startAt) OR (ScheduledDao.start_at <= :endAt AND ScheduledDao.end_at >= :endAt))'
      )
      .andWhere('ScheduledDao.user_id = :userId')
      .setParameters({
        startAt,
        endAt,
        userId
      })
      .getOne()
  }

  getRepository() {
    return this.getManager().getRepository(ScheduledDao)
  }
}
