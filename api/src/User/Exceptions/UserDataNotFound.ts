import { DataNotFoundException } from '../../Shared/Models/Exceptions/DataNotFoundException'

export class UserDataNotFound extends DataNotFoundException {
  constructor() {
    super('User data not found.')
  }
}
