import { GoogleDistanceMatrixProvider } from '../../Location/Providers/GoogleDistanceMatrixProvider'
import { ViaCepProvider } from '../../Location/Providers/ViaCepProvider'
import { AxiosRequest } from '../Modules/Request/AxiosRequest'
import { GoogleRequest } from '../Modules/Request/GoogleRequest'

export class ProviderFactory {
  public buildViaCepProvider() {
    return new ViaCepProvider(new AxiosRequest(process.env.CEP_PROVIDER_API_URL))
  }

  public buildGoogleDistanceMatrixProvider() {
    return new GoogleDistanceMatrixProvider(new GoogleRequest(process.env.GOOGLE_MAPS_KEY))
  }
}
