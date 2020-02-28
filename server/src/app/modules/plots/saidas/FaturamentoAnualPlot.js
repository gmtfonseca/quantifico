const { NfsByOrganizacao: Nfs } = require('../../../models/nfs/Nfs')
const Plot = require('../Plot')
const RangeQueryBuilder = require('../../database/RangeQueryBuilder')

/**
 * Gráfico com faturamento anual de N anos
 * @param  {Integer} anoInicial
 * @param  {Integer} anoFinal
 */
class FaturamentoAnualPlot extends Plot {
  constructor (organizacao, anoInicial, anoFinal) {
    super(organizacao)
    this.anoInicial = anoInicial
    this.anoFinal = anoFinal
  }

  pipeline () {
    const pipeline = []
    const rangeQueryBuilder = new RangeQueryBuilder('dataEmissaoDecomposta.ano')
    pipeline.push(rangeQueryBuilder.build(this.anoInicial, this.anoFinal))
    pipeline.push({
      $group: {
        _id: { ano: '$dataEmissaoDecomposta.ano' },
        totalFaturado: { $sum: '$total.nf' }
      }
    },
    {
      $project: {
        ano: '$_id.ano',
        totalFaturado: '$totalFaturado',
        _id: false
      }
    },
    {
      $sort: { ano: 1 }
    })

    return pipeline
  }

  async getDados (pipeline) {
    const dados = await Nfs(this.organizacao).aggregate(pipeline)
    return dados
  }
}

module.exports = FaturamentoAnualPlot
