import axios, { AxiosInstance, AxiosResponse } from 'axios'
import { HttpMethodEnum } from '../../../Base/Enums/HttpMethodEnum'
import { ProviderResponse } from '../../Models/ProviderResponse'
import { BaseRequest } from './BaseRequest'

export class AxiosRequest extends BaseRequest<AxiosInstance> {
  constructor(private baseURL: string) {
    super()
  }

  public setBaseURL(baseURL: string) {
    this.baseURL = baseURL
    return this
  }

  createInstance(): this {
    if (this.instance) throw new Error('Instance already exists.')

    this.instance = axios.create({
      baseURL: this.baseURL
    })

    return this
  }

  public withHeaders(headers: any): this {
    this.instance.defaults.headers = headers
    return this
  }

  public addHeader(name: string, value: string): this {
    return this.withHeaders({
      ...this.instance.defaults.headers,
      [name]: value
    })
  }

  public getFullEndpoint(): string {
    let endpoint = this.endpoint
    if (this.params) {
      const params = []
      Object.keys(this.params).forEach(key => {
        params.push(`${key}=${this.params[key]}`)
      })

      endpoint += `${endpoint?.includes('?') ? '&' : '?'}${params.join('&')}`
    }

    return endpoint
  }

  public async send<T = any>(method: HttpMethodEnum): Promise<ProviderResponse<T>> {
    try {
      let response: AxiosResponse<T> = null

      switch (method) {
        case HttpMethodEnum.DELETE:
        case HttpMethodEnum.GET:
          response = await this.instance[method](this.getFullEndpoint())
          break

        case HttpMethodEnum.PATCH:
        case HttpMethodEnum.POST:
        case HttpMethodEnum.PUT:
          response = await this.instance[method](this.getFullEndpoint(), this.getPayload())
          break
      }

      return new ProviderResponse(response.status, response.data)
    } catch (e) {
      throw e
    } finally {
      this.clear()
    }
  }
}
