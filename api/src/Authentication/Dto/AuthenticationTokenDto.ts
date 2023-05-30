import { UserRoleTypeEnum } from '../../User/Enums/UserRoleTypeEnum'

export interface AuthenticationTokenDto {
  user: {
    id: string
    name: string
    email: string
    roleType: UserRoleTypeEnum
  }
  organization: {
    id: string
  }
}
