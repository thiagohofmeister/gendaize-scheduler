import * as fs from 'fs'
import * as path from 'path'

export class PathUtils {
  private static pathes

  constructor() {}

  public static getEntities() {
    return PathUtils.getDomains()
      .map(domain => {
        return PathUtils.getPathes()[domain].models?.dao
      })
      .filter(dao => !!dao)
  }

  public static getFileNames(path: string) {
    return fs
      .readdirSync(path, { withFileTypes: true })
      .filter(file => !file.isDirectory())
      .map(file => file.name)
  }

  public static getDomain(domainName: string) {
    return this.getPathes()[domainName]
  }

  public static getRepository(domainName: string) {
    const path = PathUtils.getDomain(domainName)['repository']

    if (!path) return null

    return require(PathUtils.getDomain(domainName)['repository'])[`${domainName}Repository`]
  }

  public static getRoute(domainName: string) {
    const path = PathUtils.getDomain(domainName)['routes']

    if (!path) return null

    return require(PathUtils.getDomain(domainName)['routes'])[`${domainName}Routes`]
  }

  public static getController(domainName: string) {
    const path = PathUtils.getDomain(domainName)['controller']

    if (!path) return null

    return require(PathUtils.getDomain(domainName)['controller'])[`${domainName}Controller`]
  }

  public static getService(domainName: string) {
    const path = PathUtils.getDomain(domainName)['service']

    if (!path) return null

    return require(PathUtils.getDomain(domainName)['service'])[`${domainName}Service`]
  }

  public static getValidator(domainName: string) {
    const path = PathUtils.getDomain(domainName)['validator']

    if (!path) return null

    return require(PathUtils.getDomain(domainName)['validator'])[`${domainName}Validator`]
  }

  public static getPathes() {
    if (!this.pathes) {
      this.fillPathes()
    }

    return this.pathes
  }

  public static getDomains() {
    this.getPathes()
    return Object.keys(this.pathes)
  }

  public static getResourcesPath() {
    return path.join(__dirname, '..', '..', '..', 'resources')
  }

  public static fillPathes() {
    const rootDir = path.join(__dirname, '..', '..')
    const domains = {}

    const domainsPath = fs
      .readdirSync(rootDir, { withFileTypes: true })
      .filter(dir => dir.isDirectory())
      .map(dir => dir.name)

    domainsPath.forEach(domainName => {
      const domainPath = path.join(rootDir, domainName)

      if (!fs.existsSync(domainPath)) {
        return
      }

      let files = this.getFileNames(domainPath).reduce((prev, curr) => {
        const slices = curr.split(/(?=[A-Z\.])/)
        const type = slices[slices.length - 2]

        prev = {
          ...prev,
          [type.toLocaleLowerCase()]: path.join(domainPath, slices.join(''))
        }

        return prev
      }, {})

      const modelsPath = path.join(domainPath, 'Models')

      if (fs.existsSync(modelsPath)) {
        files['models'] = this.getFileNames(modelsPath).reduce((prev, curr) => {
          const slices = curr.split(/(?=[A-Z\.])/)
          const isDao = slices[slices.length - 2].toLocaleLowerCase() === 'dao'

          prev = {
            ...prev,
            [isDao ? 'dao' : 'domain']: path.join(modelsPath, slices.join(''))
          }

          return prev
        }, {})
      }

      domains[domainName] = { ...files }
    })

    this.pathes = domains
  }
}
