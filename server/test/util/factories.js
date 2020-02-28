const faker = require('faker')
const { factory } = require('factory-girl')

const {
  UsuarioByOrganizacao: Usuario
} = require('../../src/app/models/Usuario')
const Organizacao = require('../../src/app/models/Organizacao')
const { NfsByOrganizacao: Nfs } = require('../../src/app/models/nfs/Nfs')

const usuarioFaker = () => ({
  nome: faker.name.findName(),
  email: faker.internet.email(),
  senha: faker.internet.password(),
  organizacao: faker.random.number(123044872893)
})

const organizacaoFaker = () => ({
  cnpj: faker.random.number(123044872893),
  razaoSocial: faker.company.companyName(),
  fantasia: faker.company.companyName()
})

const nfsFaker = () => ({
  idSefaz: faker.random.number(5182905818397),
  serie: faker.random.number(9),
  numero: faker.random.number(9),
  naturezaOperacao: String,
  cliente: {
    cnpj: faker.random.number(123044872893),
    razaoSocial: faker.company.companyName()
  },
  organizacao: faker.random.number(123044872893),
  dataEmissao: faker.date.past(10)
})

factory.define('Usuario', Usuario('*'), usuarioFaker)
factory.define('Organizacao', Organizacao, organizacaoFaker)
factory.define('Nfs', Nfs('*'), nfsFaker)

module.exports = { factory, usuarioFaker, organizacaoFaker }
