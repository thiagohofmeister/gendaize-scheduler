import { DataSource } from 'typeorm'
import { BaseService } from '../Base/BaseService'
import { HeadquarterService } from '../Headquarter/HeadquarterService'
import { DataNotFoundException } from '../Shared/Models/Exceptions/DataNotFoundException'
import { FilterDefault } from '../Shared/Models/Interfaces/FilterDefault'
import { ListResponseModel } from '../Shared/Models/Interfaces/ListResponseModel'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { CalculateDistanceDto } from './Dto/CalculateDistanceDto'
import { GetZipCodeByAddressDto } from './Dto/GetZipCodeByAddressDto'
import { LocationRepository } from './LocationRepository'
import { Distance } from './Models/Distance'
import { Location } from './Models/Location'
import { ZipCode } from './Models/ZipCode'
import { GoogleDistanceMatrixProvider } from './Providers/GoogleDistanceMatrixProvider'
import { ViaCepProvider } from './Providers/ViaCepProvider'

@ServiceDecorator
export class LocationService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly repository: LocationRepository,
    private readonly headquarterService: HeadquarterService,
    private readonly viaCepProvider: ViaCepProvider,
    private readonly googleDistanceMatrixProvider: GoogleDistanceMatrixProvider
  ) {
    super(dataSource)
  }

  public async findLocationByAddress(body: GetZipCodeByAddressDto): Promise<ZipCode[]> {
    return this.viaCepProvider.getZipCodeByAddress(body)
  }

  public async get(filter: FilterDefault): Promise<ListResponseModel<Location>> {
    return this.repository.findAll(filter, false, true)
  }

  public async getOneById(id: string): Promise<Location> {
    const location = await this.repository.findOneByPrimaryColumn(id)

    if (location) return location

    throw new DataNotFoundException()
  }

  public async findOneByZipCode(zipCode: string): Promise<ZipCode> {
    return this.viaCepProvider.getOneByZipCode(zipCode)
  }

  public async calculateDistances(body: CalculateDistanceDto): Promise<Distance[]> {
    if (!body.city || !body.street) {
      const destination = await this.findOneByZipCode(body.zipCode)
      body.city = destination.getCity()
      body.street = destination.getStreet()
    }

    const headquarters = await this.headquarterService.get({})

    const distances = []

    if (!headquarters.total) {
      return distances
    }

    await Promise.all(
      headquarters.items.map(async headquarter => {
        const distance = await this.googleDistanceMatrixProvider.calculateDistance(
          headquarter.getFullAddress(),
          this.formatAddress(body)
        )

        distances.push(distance.setHeadquarter(headquarter))
      })
    )

    return distances
  }

  private formatAddress(address: CalculateDistanceDto) {
    const infos = [address.street, address.number, address.city, address.zipCode]

    return infos.filter(i => !!i).join(' ')
  }
}
