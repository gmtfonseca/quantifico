const supertest = require('supertest')
const app = require('../../src/server')
const database = require('../util/database')
const { factory } = require('../util/factories')

const request = supertest(app)

describe('Autenticação /sessao', () => {
  beforeAll(database.abreConexao)
  afterAll(database.fechaConexao)

  describe('POST', () => {
    it('deve validar campos obrigatórios', async () => {
      const resposta = await request.post('/sessao').send({
        email: '',
        senha: '1234567'
      })

      expect(resposta.status).toBe(400)
    })

    it('deve ser possível se autenticar com credenciais válidas', async () => {
      const usuario = await factory.create('Usuario', {
        senha: '1234567'
      })

      const resposta = await request.post('/sessao').send({
        email: usuario.email,
        senha: '1234567'
      })

      expect(resposta.status).toBe(200)
    })

    it('não deve ser possível autenticar com credenciais inválidas', async () => {
      const usuario = await factory.create('Usuario')

      const resposta = await request.post('/sessao').send({
        email: usuario.email,
        senha: '1234'
      })

      expect(resposta.status).toBe(401)
    })

    it('deve retornar jwt (token) quando autenticado', async () => {
      const usuario = await factory.create('Usuario', {
        senha: '1234567'
      })

      const resposta = await request.post('/sessao').send({
        email: usuario.email,
        senha: '1234567'
      })

      expect(resposta.body).toHaveProperty('token')
    })
  })
})
