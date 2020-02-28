const ArquivoNf = require('../nfs/ArquivoNf')
// const DatabaseUtil = require('../utils/DatabaseUtil')

class SyncNfsStream {
  constructor (nfsModel) {
    this.nfsModel = nfsModel
    this.dados = ''
    this.promisesInsercaoNfs = []
    this.arquivosInvalidos = []
  }

  recebeDadosNfsSaida (dados) {
    this.dados += dados
    try {
      const arquivo = JSON.parse(this.dados.toString('utf8'))
      this.promisesInsercaoNfs.push(this.criaNfs(arquivo))
      this.dados = ''
    } catch (e) {}
  }

  async criaNfs (arquivo) {
    const arquivoNf = new ArquivoNf(
      arquivo.fileProperties.name,
      arquivo.fileProperties.modified,
      arquivo.content
    )

    try {
      const nfs = await this.nfsModel.insereFromArquivo(arquivoNf)
      return nfs
    } catch (error) {
      console.log(error)
      this.arquivosInvalidos.push({
        state: arquivoNf.getEstado(),
        error: error.errmsg
      })
    }
  }

  insereNfsSaida () {
    return Promise.all(this.promisesInsercaoNfs)
  }
}

module.exports = SyncNfsStream
