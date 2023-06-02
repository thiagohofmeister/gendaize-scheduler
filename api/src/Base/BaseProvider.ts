import { BaseRequest } from '../Shared/Modules/Request/BaseRequest'

export abstract class BaseProvider<TRequest extends BaseRequest> {
  constructor(readonly request: TRequest) {}

  protected getRequest(): TRequest {
    return this.request.createInstance().withHeaders(this.getDefaultHeaders())
  }

  protected getDefaultHeaders(): any {
    return {}
  }
}
