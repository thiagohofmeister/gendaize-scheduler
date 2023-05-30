import { Organization } from '../../../Organization/Models/Organization'

export interface ApiContext {
  organization?: Organization
  organizationId?: string
  isCustomer?: boolean
  user?: {
    id?: string
    email?: string
    roleType: string
  }
}
