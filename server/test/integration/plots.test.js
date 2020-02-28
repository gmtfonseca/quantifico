const database = require('../util/database')
const { factory } = require('../util/factories')
const FaturamentoAnualPlot = require('../../src/app/modules/plots/saidas/FaturamentoAnualPlot')

describe('Gráficos', () => {
  beforeAll(database.abreConexao)
  afterAll(database.fechaConexao)

  describe('Faturamento anual', function () {
    let organizacao = null
    beforeAll(async function () {
      organizacao = await factory.create('Organizacao')

      await factory.createMany('Nfs', 10, {
        organizacao: organizacao.id,
        dataEmissao: new Date('2013-03-03'),
        total: { nf: 10.5 }
      })
      await factory.createMany('Nfs', 10, {
        organizacao: organizacao.id,
        dataEmissao: new Date('2014-03-03'),
        total: { nf: 15.5 }
      })
      await factory.createMany('Nfs', 10, {
        organizacao: organizacao.id,
        dataEmissao: new Date('2015-03-03'),
        total: { nf: 20.5 }
      })
    })

    it('deve retornar dados corretos', async function () {
      const faturamentoAnualPlot = new FaturamentoAnualPlot(organizacao.id)
      const dados = await faturamentoAnualPlot.build()
      expect(dados.length).toBe(3)
      expect(dados[0].totalFaturado).toBe(105)
      expect(dados[1].totalFaturado).toBe(155)
      expect(dados[2].totalFaturado).toBe(205)
      expect(dados[0].ano).toBe(2013)
      expect(dados[1].ano).toBe(2014)
      expect(dados[2].ano).toBe(2015)
    })

    it('deve ser possível filtar por range de anos', async function () {
      const anoInicial = 2014
      const anoFinal = 2015
      const faturamentoAnualPlot = new FaturamentoAnualPlot(
        organizacao.id,
        anoInicial,
        anoFinal
      )
      const dados = await faturamentoAnualPlot.build()
      expect(dados.length).toBe(2)
    })

    it('deve retornar array vazio', async function () {
      const anoInicial = 2020
      const faturamentoAnualPlot = new FaturamentoAnualPlot(
        organizacao.id,
        anoInicial
      )
      const dados = await faturamentoAnualPlot.build()
      expect(dados.length).toBe(0)
    })
  })
})
