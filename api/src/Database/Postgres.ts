import * as typeORM from 'typeorm'
import { DataSource } from 'typeorm'
import { PathUtils } from '../Shared/Utils/PathUtils'

export class Postgres {
  private static dataSource: DataSource

  public async createDataSource() {
    Postgres.dataSource = new typeORM.DataSource({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: PathUtils.getEntities(),
      logging: process.env.DATABASE_LOGGING === 'true'
    })

    try {
      await Postgres.dataSource.initialize()
      console.info('Database Postgres initialized.')
    } catch (e) {
      console.error('Error to initialize Database Postgres:', { e })
    }
  }

  public static getDataSource(): DataSource {
    return this.dataSource
  }
}
