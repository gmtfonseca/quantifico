const { NfsByOrganizacao: Nfs } = require('../../../models/nfs/Nfs')
const Plot = require('../Plot')
const RangeQueryBuilder = require('../../database/RangeQueryBuilder')

/**
 * Gráfico com faturamento agrupado por cidade
 * @param  {Date} dataInicial
 * @param  {Date} dataFinal
 * @param  {Integer} sort
 * @param  {Integer} limit
 */
class FaturamentoCidadePlot extends Plot {
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
          _id: {
            descricaoMunicipio: '$cliente.endereco.municipio.descricao'
          },
          totalFaturado: { $sum: '$total.nf' }
        }
      },
      {
        $project: {
          descricaoMunicipio: '$_id.descricaoMunicipio',
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
    const dados = await Nfs(this.organizacao).aggregate(pipeline)
    return dados
  }
}

module.exports = FaturamentoCidadePlot
