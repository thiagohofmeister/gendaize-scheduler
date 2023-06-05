import { randomUUID } from 'crypto'
import { DomainModel } from '../../Shared/Models/DomainModel'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { LocationDao } from './LocationDao'

export class Location implements DomainModel, ResponseModel {
  constructor(private state: string, private city: string, private id?: string) {
    if (!id) this.id = randomUUID()
  }

  public getId(): string {
    return this.id
  }

  public getCity(): string {
    return this.city
  }

  public getState(): string {
    return this.state
  }

  toView() {
    return {
      id: this.getId(),
      state: this.getState(),
      city: this.getCity()
    }
  }

  toDao() {
    return new LocationDao(this.id, this.state, this.city)
  }
}
