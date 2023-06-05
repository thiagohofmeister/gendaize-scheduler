import { Column, Entity, PrimaryColumn } from 'typeorm'
import { DaoModel } from '../../Shared/Models/DaoModel'
import { Location } from './Location'

@Entity('location')
export class LocationDao implements DaoModel {
  @PrimaryColumn()
  id: string

  @Column()
  state: string

  @Column()
  city: string

  constructor(id: string, state: string, city: string) {
    this.id = id
    this.state = state
    this.city = city
  }

  toDomain() {
    return new Location(this.state, this.city, this.id)
  }
}
