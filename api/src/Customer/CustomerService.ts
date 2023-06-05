import { DataSource } from 'typeorm'
import { AuthenticationCreateDto } from '../Authentication/Dto/AuthenticationCreateDto'
import { BaseService } from '../Base/BaseService'
import { CustomerAddress } from '../CustomerAddress/Models/CustomerAddress'
import { LocationService } from '../Location/LocationService'
import { Organization } from '../Organization/Models/Organization'
import { UnauthorizedException } from '../Shared/Models/Exceptions/UnauthorizedException'
import { StringUtils } from '../Shared/Utils/StringUtils'
import { CustomerRepository } from './CustomerRepository'
import { CustomerValidator } from './CustomerValidator'
import { CustomerCreateDto } from './Dto/CustomerCreateDto'
import { Customer } from './Models/Customer'

export class CustomerService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: CustomerRepository,
    private readonly validator: CustomerValidator,
    private readonly locationService: LocationService
  ) {
    super(dataSource)
  }

  async create(organization: Organization, data: CustomerCreateDto) {
    await this.validator.validateCreatePayload(data)

    const customer = new Customer(
      data.name,
      data.phone,
      data.email,
      data.password || StringUtils.getRandomString(),
      organization
    )

    if (!!data.address) {
      const zipCode = await this.locationService.findOneByZipCode(data.address.zipCode)

      const distances = await this.locationService.calculateDistances({
        zipCode: zipCode.getZipCode(),
        street: zipCode.getStreet(),
        city: zipCode.getCity(),
        number: data.address.number
      })

      customer.addAddress(
        new CustomerAddress(
          zipCode.getState(),
          zipCode.getCity(),
          zipCode.getDistrict(),
          zipCode.getStreet(),
          data.address.number,
          data.address.complement,
          zipCode.getZipCode(),
          distances.map(distance => ({
            distance: distance.getDistance(),
            duration: distance.getDuration(),
            headquarterId: distance.getHeadquarter().getId()
          }))
        )
      )
    }

    return this.repository.save(customer)
  }

  async findOneByAuthData(data: AuthenticationCreateDto) {
    const customer = await this.repository.findOneByAuthData(
      data.login.toLowerCase(),
      data.password
    )

    if (customer) return customer

    throw new UnauthorizedException()
  }
}
