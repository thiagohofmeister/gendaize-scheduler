export interface ScheduledCreateCalculateAmountDto {
  customerAddressesId: {
    start: string
    end: string
  }
  customerId: string
  serviceId: string
  headquarterId: string
}
