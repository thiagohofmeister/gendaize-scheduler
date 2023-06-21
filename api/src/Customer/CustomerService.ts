import { DataSource } from 'typeorm'
import { AuthenticationCreateDto } from '../Authentication/Dto/AuthenticationCreateDto'
import { BaseService } from '../Base/BaseService'
import { CustomerAddress } from '../CustomerAddress/Models/CustomerAddress'
import { LocationService } from '../Location/LocationService'
import { Organization } from '../Organization/Models/Organization'
import { DataNotFoundException } from '../Shared/Models/Exceptions/DataNotFoundException'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'
import { UnauthorizedException } from '../Shared/Models/Exceptions/UnauthorizedException'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { StringUtils } from '../Shared/Utils/StringUtils'
import { CustomerRepository } from './CustomerRepository'
import { CustomerValidator } from './CustomerValidator'
import { CustomerCreateAddressDto } from './Dto/CustomerCreateAddressDto'
import { CustomerCreateDto } from './Dto/CustomerCreateDto'
import { Customer } from './Models/Customer'

@ServiceDecorator
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
      await this.addCustomerAddress(customer, data.address)
    }

    return this.repository.save(customer)
  }

  async createAddress(id: string, data: CustomerCreateAddressDto) {
    await this.validator.validateCreateAddressPayload(data)

    const customer = await this.getById(id)

    await this.addCustomerAddress(customer, data)

    return this.repository.save(customer)
  }

  async deleteAddress(id: string, addressId: string) {
    const customer = await this.getById(id)

    customer.removeAddress(addressId)

    console.log({ addresses: customer.getAddresses() })

    return this.repository.save(customer)
  }

  private async addCustomerAddress(customer: Customer, data: CustomerCreateAddressDto) {
    if (
      customer
        .getAddresses()
        ?.some(
          address =>
            address.getZipCode() === data.zipCode &&
            address.getNumber() === data.number &&
            !!address.getComplement() === !!data.complement
        )
    ) {
      throw new InvalidDataException('Address already added.')
    }

    const zipCode = await this.locationService.findOneByZipCode(data.zipCode)

    const distances = await this.locationService.calculateDistances({
      zipCode: zipCode.getZipCode(),
      street: zipCode.getStreet(),
      city: zipCode.getCity(),
      number: data.number
    })

    customer.addAddress(
      new CustomerAddress(
        zipCode.getState(),
        zipCode.getCity(),
        zipCode.getDistrict(),
        zipCode.getStreet(),
        data.number,
        data.complement,
        data.zipCode,
        distances.map(distance => ({
          distance: distance.getDistance(),
          duration: distance.getDuration(),
          headquarterId: distance.getHeadquarter().getId()
        }))
      )
    )
  }

  async getById(id: string) {
    const customer = await this.repository.findOneByPrimaryColumn(id)

    if (customer) return customer

    throw new DataNotFoundException()
  }

  async delete(id: string) {
    await this.repository.delete(id)
  }

  async get(filter: FilterDefault) {
    return this.repository.findAll(filter, false, true)
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
