export class StringUtils {
  static getRandomString() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    let password = ''

    for (let i = 0; i < 12; i++) {
      const index = Math.floor(Math.random() * chars.length)
      password += chars.charAt(index)
    }

    return password
  }
}
