export class EndpointPermissions {
  private permissions: Permission[]

  constructor(private roleType: string) {
    this.permissions = []
  }

  public getRoleType() {
    return this.roleType
  }

  public getPermissions(): Permission[] {
    return this.permissions
  }

  public addPermission(permission: Permission) {
    const endpointExists = this.permissions.find(
      p => p.endpoint === permission.endpoint
    )

    if (!endpointExists) {
      this.permissions.push(permission)
      return this
    }

    if (!Array.isArray(endpointExists.methods)) {
      endpointExists.methods = [endpointExists.methods]
    }

    if (!Array.isArray(permission.methods)) {
      permission.methods = [permission.methods]
    }

    endpointExists.methods.push(...permission.methods)

    return this
  }
}

interface Permission {
  endpoint: string
  methods: string | string[]
}
