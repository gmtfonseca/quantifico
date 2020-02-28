class ArquivoNf {
  constructor (nome, dataModificacaoSegundos, conteudo) {
    this.nome = nome
    this.dataModificacaoSegundos = dataModificacaoSegundos
    this.conteudo = conteudo
  }

  getEstado () {
    return `${this.nome}/${this.dataModificacaoSegundos}`
  }
}

module.exports = ArquivoNf
