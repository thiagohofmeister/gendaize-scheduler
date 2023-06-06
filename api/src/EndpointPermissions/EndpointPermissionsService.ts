import * as fs from 'fs'
import * as path from 'path'

import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { PathUtils } from '../Shared/Utils/PathUtils'
import { EndpointPermissions } from './Models/EndpointPermissions'

@ServiceDecorator
export class EndpointPermissionsService {
  constructor() {}

  public async get(): Promise<EndpointPermissions[]> {
    const fileContent = fs
      .readFileSync(path.join(PathUtils.getResourcesPath(), 'endpointPermissions.json'))
      .toString()

    const endpointPermissions = []

    JSON.parse(fileContent).forEach(({ roleType, permissions }) => {
      const endpointPermission = new EndpointPermissions(roleType)

      permissions.forEach(permission => endpointPermission.addPermission(permission))

      endpointPermissions.push(endpointPermission)
    })

    return endpointPermissions
  }
}
