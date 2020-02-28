const { SaidaByOrganizacao: Saida } = require('../Saida')

module.exports = schema => {
  // Hooks ao nível do documento

  schema.pre('save', { document: true }, function (next) {
    if (this.dataEmissao) {
      this.dataEmissaoDecomposta = {
        dia: this.dataEmissao.getDate(),
        mes: this.dataEmissao.getMonth() + 1,
        ano: this.dataEmissao.getFullYear()
      }
    }

    next()
  })

  schema.pre('remove', { document: true }, async function (next) {
    try {
      await Saida(this.organizacao).deleteMany({ _id: { $in: this.saidas } })
    } catch (error) {
      next(error)
    }
  })
}
