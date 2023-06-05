import { Headquarter } from '../../Headquarter/Models/Headquarter'
import { ResponseModel } from '../../Shared/Models/ResponseModel'

export class Distance implements ResponseModel {
  private headquarter: Headquarter

  constructor(
    private originAddress: string,
    private destinationAddress: string,
    private distance: number,
    private duration: number
  ) {}

  public getOriginAddress(): string {
    return this.originAddress
  }

  public getDestinationAddress(): string {
    return this.destinationAddress
  }

  public getDistance(): number {
    return this.distance
  }

  public getDuration(): number {
    return this.duration
  }

  public getHeadquarter(): Headquarter {
    return this.headquarter
  }

  public setHeadquarter(headquarter: Headquarter) {
    this.headquarter = headquarter
    return this
  }

  toView() {
    return {
      originAddress: this.getOriginAddress(),
      destinationAddress: this.getDestinationAddress(),
      distance: this.getDistance(),
      headquarter: this.getHeadquarter()?.toView()
    }
  }
}
