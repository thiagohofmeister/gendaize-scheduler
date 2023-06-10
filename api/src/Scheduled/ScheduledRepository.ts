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
      .leftJoinAndSelect('ScheduledDao.headquarter', 'headquarter')
      .leftJoinAndSelect('ScheduledDao.service', 'service')
  }

  protected customToFindAll(
    query: SelectQueryBuilder<ScheduledDao>,
    filter?: ScheduledFilter
  ): SelectQueryBuilder<ScheduledDao> {
    if (filter.periodity) {
      let startAt = new Date()
      startAt.setHours(0)
      startAt.setMinutes(0)
      startAt.setSeconds(0)

      let endAt = new Date()
      endAt.setHours(23)
      endAt.setMinutes(59)
      endAt.setSeconds(59)

      switch (filter.periodity) {
        case ScheduledPeriodityEnum.TOMORROW:
          startAt.setDate(startAt.getDate() + 1)
          endAt.setDate(endAt.getDate() + 1)

          break

        case ScheduledPeriodityEnum.MONTH:
          startAt.setDate(1)

          endAt.setMonth(endAt.getMonth() + 1)
          endAt.setDate(1)
          endAt.setHours(0)
          endAt.setMinutes(0)
          endAt.setSeconds(-1)

          break

        case ScheduledPeriodityEnum.WEEK:
          startAt.setDate(startAt.getDate() - startAt.getDay())

          if (endAt.getDay() !== 6) {
            endAt.setDate(endAt.getDate() + 6 - endAt.getDay())
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
      .leftJoinAndSelect('ScheduledDao.headquarter', 'headquarter')
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
