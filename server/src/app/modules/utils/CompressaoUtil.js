const { promisify } = require('util')
const deflate = promisify(require('zlib').deflate)
const inflate = promisify(require('zlib').inflate)

class CompressaoUtil {
  static async toStringBase64 (object) {
    try {
      const json = JSON.stringify(object)
      const jsonComprimido = await deflate(json)
      return jsonComprimido.toString('base64')
    } catch (e) {
      throw e
    }
  }

  static async toObject (string) {
    try {
      const stringBase64Buffer = Buffer.from(string, 'base64')
      const jsonBuffer = await inflate(stringBase64Buffer)
      const json = jsonBuffer.toString()
      const object = JSON.parse(json)
      return object
    } catch (e) {
      throw e
    }
  }
}

module.exports = CompressaoUtil
