import { NotFoundException } from './NotFoundException'

export class DataNotFoundException extends NotFoundException {
  constructor(message: string = 'Item not found.') {
    super(message)
  }
}
