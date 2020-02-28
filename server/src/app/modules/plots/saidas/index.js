const FaturamentoClientePlot = require('./FaturamentoClientePlot')
const FaturamentoProdutoPlot = require('./FaturamentoProdutoPlot')
const FaturamentoCidadePlot = require('./FaturamentoCidadePlot')
const FaturamentoMensalPlot = require('./FaturamentoMensalPlot')
const FaturamentoAnualPlot = require('./FaturamentoAnualPlot')
const QueryUtil = require('../../utils/QueryUtil')

const faturamentoCliente = async (organizacao, query) => {
  const faturamentoClientePlot = new FaturamentoClientePlot(
    organizacao,
    query.datainicial ? new Date(query.datainicial) : null,
    query.datafinal ? new Date(query.datafinal) : null,
    query.sort,
    query.limit
  )
  const dados = await faturamentoClientePlot.build()
  return dados
}

const faturamentoCidade = async (organizacao, query) => {
  const faturamentoCidadePlot = new FaturamentoCidadePlot(
    organizacao,
    query.datainicial ? new Date(query.datainicial) : null,
    query.datafinal ? new Date(query.datafinal) : null,
    query.sort,
    query.limit
  )
  const dados = await faturamentoCidadePlot.build()
  return dados
}

const faturamentoMensal = async (organizacao, query) => {
  const anos = QueryUtil.toArray(query.anos).map(ano => Number(ano))
  const faturamentoMensalPlot = new FaturamentoMensalPlot(
    organizacao,
    anos
  )
  const dados = await faturamentoMensalPlot.build()
  return dados
}

const faturamentoAnual = async (organizacao, query) => {
  const faturamentoAnualPlot = new FaturamentoAnualPlot(
    organizacao,
    query.anoinicial ? Number(query.anoinicial) : null,
    query.anofinal ? Number(query.anofinal) : null
  )
  const dados = await faturamentoAnualPlot.build()
  return dados
}

const faturamentoProduto = async (organizacao, query) => {
  const faturamentoProdutoPlot = new FaturamentoProdutoPlot(
    organizacao,
    query.datainicial ? new Date(query.datainicial) : null,
    query.datafinal ? new Date(query.datafinal) : null,
    query.sort,
    query.limit
  )
  const dados = await faturamentoProdutoPlot.build()
  return dados
}

module.exports = {
  'faturamento-cliente': faturamentoCliente,
  'faturamento-cidade': faturamentoCidade,
  'faturamento-mensal': faturamentoMensal,
  'faturamento-anual': faturamentoAnual,
  'faturamento-produto': faturamentoProduto
}
