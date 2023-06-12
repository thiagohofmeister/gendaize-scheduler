import { Service } from '../../Service/Models/Service'
import { ResponseModel } from '../../Shared/Models/ResponseModel'

export class ScheduledCalculateAmount implements ResponseModel {
  constructor(
    private subtotal: number,
    private taxes: number,
    private discount: number,
    private total: number,
    private service: Service
  ) {}

  public getDiscount(): number {
    return this.discount
  }

  public getTaxes(): number {
    return this.taxes
  }

  public getSubtotal(): number {
    return this.subtotal
  }

  public getTotal(): number {
    return this.total
  }

  public getService(): Service {
    return this.service
  }

  toView() {
    return {
      subtotal: this.getSubtotal(),
      taxes: this.getTaxes(),
      discount: this.getDiscount(),
      total: this.getTotal(),
      service: {
        id: this.getService().getId(),
        name: this.getService().getName()
      }
    }
  }
}
