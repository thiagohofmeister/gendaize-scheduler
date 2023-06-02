import { ListResponseModel } from '../Interfaces/ListResponseModel'
import { ResponseModel } from '../ResponseModel'

export abstract class SuccessContract {
  constructor(private body?: ResponseModel | ResponseModel[] | ListResponseModel<ResponseModel>) {}

  public getBody() {
    return this.render(this.body)
  }

  abstract getStatus(): number

  private render(
    body: ResponseModel | ResponseModel[] | ListResponseModel<ResponseModel>
  ): ResponseModel | ResponseModel[] | ListResponseModel<ResponseModel> {
    if (!body) {
      return undefined
    }

    if (Array.isArray(body)) {
      return this.renderMany(body as ResponseModel[])
    }

    if (!!body && body.hasOwnProperty('items') && body.hasOwnProperty('total')) {
      return this.renderList(body as ListResponseModel<ResponseModel>)
    }

    return this.renderOne(body as ResponseModel)
  }

  protected renderOne(entity: ResponseModel) {
    return entity.toView()
  }

  protected renderMany(entities: ResponseModel[]) {
    return entities.map(entity => this.renderOne(entity))
  }

  protected renderList(result: ListResponseModel<ResponseModel>) {
    return {
      items: result.items.map(entity => this.renderOne(entity)),
      total: result.total
    }
  }
}
