class SessaoDb {
  constructor (modelo) {
    this.modelo = modelo
    this.sessao = {}
  }

  async iniciar () {
    this.sessao = await this.modelo.startSession()
  }

  finalizar () {
    this.sessao.endSession()
    this.sessao = {}
  }

  async executar (funcComandos) {
    if (!this.sessao) {
      this.iniciarSessao()
    }

    await this.sessao.startTransaction()
    try {
      const resultado = await funcComandos()
      await this.sessao.commitTransaction()
      return resultado
    } catch (e) {
      await this.sessao.abortTransaction()
      throw e
    }
  }
}

module.exports = SessaoDb
