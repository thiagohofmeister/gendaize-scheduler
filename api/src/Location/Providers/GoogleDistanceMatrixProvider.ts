import { BaseProvider } from '../../Base/BaseProvider'
import { GoogleRequest } from '../../Shared/Modules/Request/GoogleRequest'
import { Distance } from '../Models/Distance'

export class GoogleDistanceMatrixProvider extends BaseProvider<GoogleRequest> {
  async calculateDistance(origin: string, destination: string): Promise<Distance> {
    try {
      const response = (
        await this.getRequest().distancematrix({
          origins: [origin],
          destinations: [destination]
        })
      ).getBody()

      return new Distance(
        response.origin_addresses[0],
        response.destination_addresses[0],
        response.rows[0].elements[0].distance.value,
        response.rows[0].elements[0].duration.value
      )
    } catch (e) {
      return e
    }
  }

  protected getRequest(): GoogleRequest {
    return this.request.createInstance()
  }
}
