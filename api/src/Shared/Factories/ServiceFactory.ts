import { AuthenticationService } from '../../Authentication/AuthenticationService'
import { CustomerService } from '../../Customer/CustomerService'
import { CustomerValidator } from '../../Customer/CustomerValidator'
import { EndpointPermissionsService } from '../../EndpointPermissions/EndpointPermissionsService'
import { HeadquarterService } from '../../Headquarter/HeadquarterService'
import { LocationService } from '../../Location/LocationService'
import { OrganizationService } from '../../Organization/OrganizationService'
import { OrganizationValidator } from '../../Organization/OrganizationValidator'
import { RegisterService } from '../../Register/RegisterService'
import { RegisterValidator } from '../../Register/RegisterValidator'
import { UserService } from '../../User/UserService'
import { UserValidator } from '../../User/UserValidator'
import { JWT } from '../Modules/JWT'
import { ProviderFactory } from './ProviderFactory'
import { RepositoryFactory } from './RepositoryFactory'

export class ServiceFactory {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly providerFactory: ProviderFactory
  ) {}

  buildEndpointPermissionsService() {
    return new EndpointPermissionsService()
  }

  buildAuthenticationService() {
    return new AuthenticationService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('Authentication'),
      this.buildUserService(),
      this.buildCustomerService(),
      new JWT(process.env.JWT_KEY)
    )
  }

  buildOrganizationService() {
    return new OrganizationService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('Organization'),
      new OrganizationValidator()
    )
  }

  buildRegisterService() {
    return new RegisterService(
      this.repositoryFactory.getDataSource(),
      this.buildUserService(),
      this.buildOrganizationService(),
      this.buildAuthenticationService(),
      new RegisterValidator()
    )
  }

  buildUserService() {
    return new UserService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('User'),
      new UserValidator()
    )
  }

  buildCustomerService() {
    return new CustomerService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('Customer'),
      new CustomerValidator(),
      this.buildLocationService()
    )
  }

  buildLocationService() {
    return new LocationService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('Location'),
      this.buildHeadquarterService(),
      this.providerFactory.buildViaCepProvider(),
      this.providerFactory.buildGoogleDistanceMatrixProvider()
    )
  }

  buildHeadquarterService() {
    return new HeadquarterService(
      this.repositoryFactory.getDataSource(),
      this.repositoryFactory.buildRepository('Headquarter')
    )
  }
}
