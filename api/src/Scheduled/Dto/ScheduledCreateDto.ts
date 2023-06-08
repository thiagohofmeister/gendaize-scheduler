export interface ScheduledCreateDto {
  startAt: Date
  endAt: Date
  addresses: []
  customerAddressesId: {
    start: string
    end: string
  }
  userId: string
  customerId: string
  serviceId: string
  headquarterId: string
}
