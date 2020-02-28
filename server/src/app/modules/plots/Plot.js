class Plot {
  constructor (organizacao) {
    this.organizacao = organizacao
    this._dados = []
  }

  async build () {
    this._dados = await this.getDados(this.pipeline())
    return this._dados
  }

  pipeline () {}

  async getDados (pipeline) {}

  get dados () {
    return this._dados
  }
}

module.exports = Plot
