const path = require('path')
var fs = require('fs')
const ParserNf = require('../../src/app/modules/nfs/ParserNf')

describe('Nfs parser', () => {
  it('deve ser possível realizar o parse v1.0', async () => {
    var conteudo = JSON.parse(
      fs
        .readFileSync(
          path.resolve('test', 'fixture', 'nfs', 'nf1_0.json'),
          'utf8'
        )
        .substring(1)
    )

    const nfProcessada = await ParserNf.parse(conteudo)

    expect(nfProcessada).toHaveProperty('numero')
  })

  it('deve ser possível realizar o parse v2.0', async () => {
    var conteudo = JSON.parse(
      fs
        .readFileSync(
          path.resolve('test', 'fixture', 'nfs', 'nf2_0.json'),
          'utf8'
        )
        .substring(1)
    )

    const nfProcessada = await ParserNf.parse(conteudo)

    expect(nfProcessada).toHaveProperty('numero')
  })

  it('deve ser possível realizar o parse v3.0', async () => {
    var conteudo = JSON.parse(
      fs
        .readFileSync(
          path.resolve('test', 'fixture', 'nfs', 'nf3_0.json'),
          'utf8'
        )
        .substring(1)
    )

    const nfProcessada = await ParserNf.parse(conteudo)

    expect(nfProcessada).toHaveProperty('numero')
  })

  it('deve ser possível realizar o parse v4.0', async () => {
    var conteudo = JSON.parse(
      fs
        .readFileSync(
          path.resolve('test', 'fixture', 'nfs', 'nf4_0.json'),
          'utf8'
        )
        .substring(1)
    )

    const nfProcessada = await ParserNf.parse(conteudo)

    expect(nfProcessada).toHaveProperty('numero')
  })
})
