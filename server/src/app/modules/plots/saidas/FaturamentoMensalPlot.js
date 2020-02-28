const { NfsByOrganizacao: Nfs } = require('../../../models/nfs/Nfs')
const Plot = require('../Plot')

/**
 * Gráfico com faturamento mensal de N anos
 * @param  {Array} anos
 */
class FaturamentoMensalPlot extends Plot {
  constructor (organizacao, anos) {
    super(organizacao)
    this.anos = anos
  }

  pipeline () {
    const pipeline = [
      {
        $match: {
          'dataEmissaoDecomposta.ano': { $in: this.anos }
        }
      },
      {
        $group: {
          _id: { ano: '$dataEmissaoDecomposta.ano', mes: '$dataEmissaoDecomposta.mes' },
          totalFaturado: { $sum: '$total.nf' }
        }
      },
      {
        $project: {
          ano: '$_id.ano',
          mes: '$_id.mes',
          totalFaturado: '$totalFaturado',
          _id: false
        }
      },
      {
        $sort: { ano: 1, mes: 1 }
      }
    ]

    return pipeline
  }

  async getDados (pipeline) {
    const dados = await Nfs(this.organizacao).aggregate(pipeline)
    return dados
  }
}

module.exports = FaturamentoMensalPlot
