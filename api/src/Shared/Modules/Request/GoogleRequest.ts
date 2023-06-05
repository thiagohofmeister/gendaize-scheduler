import {
  Client,
  DistanceMatrixRequest,
  DistanceMatrixResponseData
} from '@googlemaps/google-maps-services-js'

import { HttpMethodEnum } from '../../../Base/Enums/HttpMethodEnum'
import { ProviderResponse } from '../../Models/ProviderResponse'
import { BaseRequest } from './BaseRequest'

export class GoogleRequest extends BaseRequest<Client> {
  constructor(private readonly key: string) {
    super()
  }

  createInstance(): this {
    if (!this.instance) this.instance = new Client()

    return this
  }

  async distancematrix(
    params: Omit<DistanceMatrixRequest['params'], 'key'>
  ): Promise<ProviderResponse<DistanceMatrixResponseData>> {
    try {
      const response = await this.instance.distancematrix({
        params: {
          ...params,
          key: this.key
        }
      })

      return new ProviderResponse<DistanceMatrixResponseData>(response.status, response.data)
    } catch (e) {
      throw e
    }
  }

  public send<T = any>(method: HttpMethodEnum): Promise<ProviderResponse<T>> {
    throw new Error('Please use the instance directly.')
  }

  getKey() {
    return this.key
  }
}
