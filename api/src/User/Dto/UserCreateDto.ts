import { UserStatusEnum } from '../Enums/UserStatusEnum'

export interface UserCreateDto {
  name: string
  documentNumber: string
  email: string
  password: string
  status: UserStatusEnum
}
