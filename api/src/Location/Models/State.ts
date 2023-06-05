import { ResponseModel } from '../../Shared/Models/ResponseModel'

export class State implements ResponseModel {
  constructor(private readonly uf: string, private readonly cities: string[]) {}

  getUf(): string {
    return this.uf
  }

  getCities(): string[] {
    return this.cities
  }

  toView() {
    return {
      uf: this.getUf(),
      cities: this.getCities()
    }
  }
}
