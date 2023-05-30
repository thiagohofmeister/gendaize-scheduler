import { Organization } from '../../Organization/Models/Organization'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { User } from '../../User/Models/User'

export class Register implements ResponseModel {
  constructor(private user: User, private organization: Organization) {}

  public getUser() {
    return this.user
  }

  public getOrganization() {
    return this.organization
  }

  toView() {
    return {
      user: this.getUser().toView(),
      organization: this.getOrganization().toView()
    }
  }
}
