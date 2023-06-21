import { SelectQueryBuilder } from 'typeorm'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { TypeOrmMysqlRepositoryContract } from '../Shared/Modules/Repositories/TypeOrmMysqlRepositoryContract'
import { ScheduledPeriodityEnum } from './Enums/ScheduledPeriodityEnum'
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

  protected customToFindOneByPrimaryColumn(
    query: SelectQueryBuilder<ScheduledDao>
  ): SelectQueryBuilder<ScheduledDao> {
    return query
      .leftJoinAndSelect('ScheduledDao.customer', 'customer')
      .leftJoinAndSelect('ScheduledDao.user', 'user')
      .leftJoinAndSelect('ScheduledDao.service', 'service')
  }

  protected customToFindAll(
    query: SelectQueryBuilder<ScheduledDao>,
    filter?: ScheduledFilter
  ): SelectQueryBuilder<ScheduledDao> {
    if (filter.periodity) {
      let startAt = new Date()
      startAt.setUTCHours(startAt.getUTCHours() - 3)
      startAt.setUTCHours(0)
      startAt.setUTCMinutes(0)
      startAt.setUTCSeconds(0)

      let endAt = new Date()
      endAt.setUTCHours(endAt.getUTCHours() - 3)
      endAt.setUTCHours(23)
      endAt.setUTCMinutes(59)
      endAt.setUTCSeconds(59)

      switch (filter.periodity) {
        case ScheduledPeriodityEnum.TOMORROW:
          startAt.setUTCDate(startAt.getUTCDate() + 1)
          endAt.setUTCDate(endAt.getUTCDate() + 1)

          break

        case ScheduledPeriodityEnum.MONTH:
          startAt.setUTCDate(1)

          endAt.setUTCMonth(endAt.getUTCMonth() + 1)
          endAt.setUTCDate(1)
          endAt.setUTCHours(0)
          endAt.setUTCMinutes(0)
          endAt.setUTCSeconds(-1)

          break

        case ScheduledPeriodityEnum.WEEK:
          startAt.setUTCDate(startAt.getUTCDate() - startAt.getUTCDay())

          if (endAt.getUTCDay() !== 6) {
            endAt.setUTCDate(endAt.getUTCDate() + 6 - endAt.getUTCDay())
          }

          break
      }

      query
        .where('ScheduledDao.startAt >= :startAt')
        .andWhere('ScheduledDao.startAt <= :endAt')
        .setParameters({
          startAt,
          endAt
        })
    }

    return query
      .leftJoinAndSelect('ScheduledDao.customer', 'customer')
      .leftJoinAndSelect('ScheduledDao.user', 'user')
      .leftJoinAndSelect('ScheduledDao.service', 'service')
      .orderBy('ScheduledDao.startAt')
  }

  getRepository() {
    return this.getManager().getRepository(ScheduledDao)
  }
}

export interface ScheduledFilter extends FilterDefault {
  periodity?: ScheduledPeriodityEnum
}
