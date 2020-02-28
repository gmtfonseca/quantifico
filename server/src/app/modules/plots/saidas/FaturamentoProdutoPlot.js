const { SaidaByOrganizacao: Saida } = require('../../../models/Saida')
const Plot = require('../Plot')
const RangeQueryBuilder = require('../../database/RangeQueryBuilder')

/**
 * Gráfico com faturamento agrupado por cliente
 * @param  {Date} dataInicial
 * @param  {Date} dataFinal
 * @param  {Integer} sort
 * @param  {Integer} limit
 */

class FaturamentoProdutoPlot extends Plot {
  constructor (organizacao, dataInicial, dataFinal, sort, limit) {
    super(organizacao)
    this.dataInicial = dataInicial
    this.dataFinal = dataFinal
    this.sort = sort
    this.limit = limit
  }

  pipeline () {
    const pipeline = []
    const rangeQueryBuilder = new RangeQueryBuilder('dataEmissao')
    pipeline.push(rangeQueryBuilder.build(this.dataInicial, this.dataFinal))
    pipeline.push(
      {
        $group: {
          _id: { codigo: '$produto.codigo', descricao: '$produto.descricao' },
          totalFaturado: { $sum: '$valor.total' }
        }
      },
      {
        $project: {
          descricao: '$_id.descricao',
          totalFaturado: '$totalFaturado',
          _id: false
        }
      },
      {
        $sort: { totalFaturado: Number(this.sort) || -1 }
      },
      {
        $limit: Number(this.limit) || 10
      }
    )

    return pipeline
  }

  async getDados (pipeline) {
    const dados = await Saida(this.organizacao).aggregate(pipeline)
    return dados
  }
}

module.exports = FaturamentoProdutoPlot
