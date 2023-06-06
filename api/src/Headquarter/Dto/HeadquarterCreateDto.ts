import { HeadquarterSchedule } from '../Models/HeadquarterSchedule'

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
}
