import * as typeORM from 'typeorm'
import { DataSource } from 'typeorm'
import { PathUtils } from '../Shared/Utils/PathUtils'

export class Postgres {
  private static dataSource: DataSource

  public async createDataSource() {
    if (!!Postgres.dataSource) {
      console.error('Postgres instance already exists.')
      return
    }

    const entities = PathUtils.getEntities()
    Postgres.dataSource = new typeORM.DataSource({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: entities,
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
