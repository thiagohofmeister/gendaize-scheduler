export interface CustomerCreateDto {
  name: string
  phone: string
  email?: string
  password?: string
  address?: {
    zipCode: string
    number: string
    complement: string
  }
}
