import { createHash } from 'crypto'

export class EncryptUtils {
  public static password(password: string) {
    return this.createHash256(this.createHash256(password))
  }

  private static createHash256(str: string): string {
    return createHash('sha256').update(str).digest('hex')
  }
}
