import { Authentication } from '../../Authentication/Models/Authentication'
import { Organization } from '../../Organization/Models/Organization'
import { ResponseModel } from '../../Shared/Models/ResponseModel'
import { User } from '../../User/Models/User'

export class Register implements ResponseModel {
  constructor(
    private user: User,
    private organization: Organization,
    private authentication: Authentication
  ) {}

  public getUser() {
    return this.user
  }

  public getOrganization() {
    return this.organization
  }

  public getAuthentication() {
    return this.authentication
  }

  toView() {
    return {
      user: this.getUser().toView(),
      organization: this.getOrganization().toView(),
      authentication: this.getAuthentication().toView()
    }
  }
}
