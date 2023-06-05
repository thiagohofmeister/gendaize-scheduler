import { FacadeContract } from '../../Shared/Facades/Contracts/FacadeContract'
import { CalculateDistanceDTO } from './Dto/CalculateDistanceDto'
import { getLocationByAddressDTO } from './Dto/GetLocationByAddressDto'
import { Distance } from './Models/Distance'
import { State } from './Models/State'
import { ZipCode } from './Models/ZipCode'

export class LocationFacade extends FacadeContract {
  public async findLocationByAddress(body: getLocationByAddressDTO): Promise<any> {
    return await this.serviceFactory.buildLocationService().findLocationByAddress(body)
  }

  public async findStates(): Promise<State[]> {
    return await this.serviceFactory.buildLocationService().findStates()
  }

  public async findOneByLocation(zipCode: string): Promise<ZipCode> {
    return await this.serviceFactory.buildLocationService().findOneByLocation(zipCode)
  }

  public async calculateDistance(body: CalculateDistanceDTO): Promise<Distance> {
    return await this.serviceFactory.buildLocationService().calculateDistance(body)
  }
}
