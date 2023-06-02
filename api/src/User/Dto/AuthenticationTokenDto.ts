import { UserRoleTypeEnum } from '../Enums/UserRoleTypeEnum'

export interface AuthenticationTokenDto {
  user?: {
    id: string
    name: string
    email: string
    roleType: UserRoleTypeEnum
  }
  customer?: {
    id: string
    name: string
    email: string
    phone: string
  }
  organization: {
    id: string
  }
}
