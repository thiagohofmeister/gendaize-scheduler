export interface ScheduledAddress {
  originAddress: Address
  startAddress: Address
  endAddress?: Address
}

export interface Address {
  state: string
  city: string
  district: string
  street: string
  number: string
  complement?: string
  zipCode: string
}
