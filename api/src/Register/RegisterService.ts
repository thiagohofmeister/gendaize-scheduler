import { DataSource } from 'typeorm'
import { AuthenticationService } from '../Authentication/AuthenticationService'
import { BaseService } from '../Base/BaseService'
import { OrganizationService } from '../Organization/OrganizationService'
import { InvalidDataException } from '../Shared/Models/Exceptions/InvalidDataException'
import { ServiceDecorator } from '../Shared/Utils/DecoratorUtils'
import { UserService } from '../User/UserService'
import { RegisterCreateDto } from './Dto/RegisterCreateDto'
import { Register } from './Models/Register'
import { RegisterValidator } from './RegisterValidator'

@ServiceDecorator
export class RegisterService extends BaseService {
  constructor(
    dataSource: DataSource,
    private readonly userService: UserService,
    private readonly organizationService: OrganizationService,
    private readonly authenticationService: AuthenticationService,
    private readonly validator: RegisterValidator
  ) {
    super(dataSource)
  }

  public async create(data: RegisterCreateDto) {
    return this.transactionalFn(async manager => {
      await this.validator.registerCreatePayloadValidate(data)

      const invalidDataException = new InvalidDataException('Invalid data.')

      await this.validateIfUserAlreadyExists(data.user.documentNumber, invalidDataException)

      await this.validateIfOrganizationAlreadyExists(
        data.organization.document.number,
        invalidDataException
      )

      if (!!invalidDataException.getReasons().length) {
        throw invalidDataException
      }

      const organization = await this.organizationService
        .setManager(manager)
        .create(data.organization)

      const user = await this.userService.setManager(manager).create(organization, data.user)

      const authentication = await this.authenticationService
        .setManager(manager)
        .authenticateUser(user, data.device)

      return new Register(user, organization, authentication)
    })
  }

  private async validateIfUserAlreadyExists(
    documentNumber: string,
    invalidDataException: InvalidDataException
  ) {
    if (!(await this.userService.findOneByDocumentNumber(documentNumber))) return

    invalidDataException.addReason({
      id: `user.documentNumber.${documentNumber}.alreadyExists`,
      message: `Field user.documentNumber.${documentNumber} is already exists.`
    })
  }

  private async validateIfOrganizationAlreadyExists(
    documentNumber: string,
    invalidDataException: InvalidDataException
  ) {
    if (!(await this.userService.findOneByDocumentNumber(documentNumber))) return

    invalidDataException.addReason({
      id: `organization.document.number.${documentNumber}.alreadyExists`,
      message: `Field organization.document.number.${documentNumber} is already exists.`
    })
  }
}
