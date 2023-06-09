import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { CustomerService } from '../Customer/CustomerService'
import { CustomerAddress } from '../CustomerAddress/Models/CustomerAddress'
import { HeadquarterService } from '../Headquarter/HeadquarterService'
import { Service } from '../Service/Models/Service'
import { ServiceService } from '../Service/ServiceService'
import { ConflictException } from '../Shared/Models/Exceptions/ConflictException'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { User } from '../User/Models/User'
import { UserService } from '../User/UserService'
import { ScheduledCreateDto } from './Dto/ScheduledCreateDto'
import { ScheduledStatusEnum } from './Enums/ScheduledStatusEnum'
import { Scheduled } from './Models/Scheduled'
import { Address, ScheduledAddress } from './Models/ScheduledAddress'
import { ScheduledAmount } from './Models/ScheduledAmount'
import { ScheduledRepository } from './ScheduledRepository'
import { ScheduledValidator } from './ScheduledValidator'

@ServiceDecorator
export class ScheduledService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: ScheduledRepository,
    private readonly validator: ScheduledValidator,
    private readonly headquarterService: HeadquarterService,
    private readonly userService: UserService,
    private readonly customerService: CustomerService,
    private readonly serviceService: ServiceService
  ) {
    super(dataSource)
  }

  async delete(id: string) {
    await this.repository.delete(id)
  }

  async get(filter: FilterDefault): Promise<ListResponseModel<Scheduled>> {
    return this.repository.findAll(filter)
  }

  async create(data: ScheduledCreateDto) {
    await this.validator.validateCreatePayload(data)

    const headquarter = await this.headquarterService.getById(data.headquarterId)

    if (!headquarter) {
      throw new InvalidDataException(`Headquarter with id ${data.headquarterId} not found.`)
    }

    const user = await this.userService.getById(data.userId)

    if (!user) {
      throw new InvalidDataException(`User with id ${data.userId} not found.`)
    }

    const customer = await this.customerService.getById(data.customerId)

    if (!customer) {
      throw new InvalidDataException(`Customer with id ${data.customerId} not found.`)
    }

    const service = await this.serviceService.getById(data.serviceId)

    if (!service) {
      throw new InvalidDataException(`Service with id ${data.serviceId} not found.`)
    }

    const startAt = new Date(data.startAt)

    const endAt = new Date(data.startAt)
    endAt.setMinutes(startAt.getMinutes() + service.getDuration())

    await this.validateAvailableSchedule(startAt, endAt, user)

    const customerStartAddress = customer.getAddress(data.customerAddressesId.start)

    const addresses: ScheduledAddress = {
      originAddress: {
        zipCode: headquarter.getAddressZipCode(),
        state: headquarter.getAddressState(),
        city: headquarter.getAddressCity(),
        district: headquarter.getAddressDistrict(),
        street: headquarter.getAddressStreet(),
        number: headquarter.getAddressNumber(),
        complement: headquarter.getAddressComplement()
      },
      startAddress: this.formatCustomerAddress(customerStartAddress)
    }

    if (data.customerAddressesId.end) {
      const customerEndAddress = customer.getAddress(data.customerAddressesId.end)

      addresses.endAddress = this.formatCustomerAddress(customerEndAddress)
    }

    const distance =
      customerStartAddress
        .getDistances()
        .find(distance => distance.headquarterId === headquarter.getId())?.distance || 0

    const scheduled = new Scheduled(
      data.startAt,
      endAt,
      ScheduledStatusEnum.CONFIRMED,
      addresses,
      this.calculatePrice(service, distance),
      user,
      customer,
      service,
      headquarter
    )

    return this.repository.save(scheduled)
  }

  private async validateAvailableSchedule(startAt: Date, endAt: Date, user: User) {
    const scheduled = await this.repository.getByStartAtAndEndAtAndUserId(
      startAt,
      endAt,
      user.getId()
    )

    if (scheduled) {
      throw new ConflictException('There is already a scheduled service for this time.')
    }
  }

  private calculatePrice(service: Service, distance: number): ScheduledAmount {
    let taxes = 0

    service.getTaxes()?.forEach(tax => {
      taxes += tax.getFinalValue(service.getPrice(), distance)
    })

    const discount = 0 // TODO: Implement discount

    return {
      subtotal: service.getPrice(),
      discount,
      taxes,
      total: service.getPrice() + taxes - discount
    }
  }

  private formatCustomerAddress(customerAddress: CustomerAddress): Address {
    return {
      zipCode: customerAddress.getZipCode(),
      state: customerAddress.getState(),
      district: customerAddress.getDistrict(),
      city: customerAddress.getCity(),
      street: customerAddress.getStreet(),
      number: customerAddress.getNumber(),
      complement: customerAddress.getComplement()
    }
  }
}
