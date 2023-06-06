import { Column, Entity } from 'typeorm'

@Entity('headquarter_location')
export class HeadquarterLocationDao {
  @Column({
    name: 'headquarter_id',
    primary: true
  })
  headquarterId: string

  @Column({
    name: 'location_id',
    primary: true
  })
  locationId: string
}
