import { Organization } from '../../../Organization/Models/Organization'

export interface ApiContext {
  organization?: Organization
  organizationId?: string
  authenticationId?: string
  customer?: {
    id: string
    name: string
    email: string
    phone: string
  }
  user?: {
    id?: string
    email?: string
    roleType: string
  }
}
