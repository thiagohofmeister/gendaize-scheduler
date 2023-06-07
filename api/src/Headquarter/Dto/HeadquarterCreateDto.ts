import { HeadquarterSchedule } from '../Models/HeadquarterSchedule'
import { HeadquarterUpdateLocationDto } from './HeadquarterUpdateLocationDto'

export interface HeadquarterCreateDto {
  name: string
  address: {
    state: string
    city: string
    district: string
    street: string
    number: string
    complement: string
    zipCode: string
  }
  schedules: HeadquarterSchedule
  locations: HeadquarterUpdateLocationDto[]
}
