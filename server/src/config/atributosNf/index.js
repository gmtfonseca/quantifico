const atributosNfv1 = require('./atributosNfv1')
const atributosNfv2 = require('./atributosNfv2')
const atributosNfv3 = require('./atributosNfv3')
const atributosNfv4 = require('./atributosNfv4')

module.exports = {
  buscaAtributosNf (versao) {
    switch (versao) {
      case '1.0':
        return atributosNfv1
      case '2.0':
        return atributosNfv2
      case '3.0':
        return atributosNfv3
      case '4.0':
        return atributosNfv4
      default:
        break
    }
  }
}
