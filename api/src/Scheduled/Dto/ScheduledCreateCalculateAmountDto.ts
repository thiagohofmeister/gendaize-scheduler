export interface ScheduledCreateCalculateAmountDto {
  customerAddressesId: {
    start: string
    end: string
  }
  customerId: string
  services: {
    id: string
  }[]
  headquarterId: string
}
