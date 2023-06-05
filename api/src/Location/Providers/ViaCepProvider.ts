import { BaseProvider } from '../../Base/BaseProvider'
import { HttpMethodEnum } from '../../Base/Enums/HttpMethodEnum'
import { AxiosRequest } from '../../Shared/Modules/Request/AxiosRequest'
import { GetZipCodeByAddressDto } from '../Dto/GetZipCodeByAddressDto'
import { ZipCode } from '../Models/ZipCode'

export class ViaCepProvider extends BaseProvider<AxiosRequest> implements ViaCepProvider {
  async getZipCodeByAddress(body: GetZipCodeByAddressDto): Promise<ZipCode[]> {
    const result = (
      await this.getRequest()
        .withEndpoint(encodeURIComponent(`/${body.uf}/${body.city}/${body.street}/json`))
        .send<ZipCodeGetOneResponse[]>(HttpMethodEnum.GET)
    ).getBody()

    return result.map(item => this.format(item))
  }

  async getOneByZipCode(zipCode: string) {
    const result = (
      await this.getRequest()
        .withEndpoint(`/${zipCode}/json`)
        .send<ZipCodeGetOneResponse>(HttpMethodEnum.GET)
    ).getBody()

    return this.format(result)
  }

  private format(response: ZipCodeGetOneResponse) {
    return new ZipCode(
      response.cep,
      response.logradouro,
      response.complemento,
      response.bairro,
      response.localidade,
      response.uf
    )
  }
}

type ZipCodeGetOneResponse = {
  cep: string
  logradouro: string
  complemento: string
  bairro: string
  localidade: string
  uf: string
  ibge: string
  gia: string
  ddd: string
  siafi: string
}
