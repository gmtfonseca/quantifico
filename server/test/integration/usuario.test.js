const supertest = require('supertest')
const app = require('../../src/server')
const { usuarioFaker, factory } = require('../util/factories')
const {
  UsuarioByOrganizacao: Usuario
} = require('../../src/app/models/Usuario')
const database = require('../util/database')

const request = supertest(app)

describe('Usuário /usuario', () => {
  beforeAll(database.abreConexao)
  afterAll(database.fechaConexao)

  describe('POST', () => {
    it('deve validar campos obrigatórios', async () => {
      const usuario = usuarioFaker()
      usuario.email = ''

      const resposta = await request.post('/usuario').send(usuario)

      expect(resposta.status).toBe(400)
    })

    it('deve ser possível criar um usuário', async () => {
      const usuario = usuarioFaker()

      const resposta = await request.post('/usuario').send(usuario)

      expect(resposta.status).toBe(200)
    })

    it('deve pertencer a uma organização', async () => {
      const usuario = usuarioFaker()

      const resposta = await request.post('/usuario').send(usuario)

      expect(resposta.body).toHaveProperty('organizacao')
    })
  })
  describe('GET', () => {
    it('não deve consultar usuário de outra organização', async () => {
      const usuario = await factory.createMany('Usuario', 2)

      const resposta = await request
        .get(`/usuario/${usuario[1]._id}`)
        .set(
          'Authorization',
          `Bearer ${Usuario('*').generateToken(usuario[0])}`
        )

      expect(resposta.body).toBe(null)
    })

    it('deve ser possível consultar usuário se token é válido', async () => {
      const usuario = await factory.create('Usuario')

      const resposta = await request
        .get(`/usuario/${usuario._id}`)
        .set('Authorization', `Bearer ${Usuario('*').generateToken(usuario)}`)

      expect(resposta.status).toBe(200)
    })

    it('não deve ser possível consultar usuário se token é inválido', async () => {
      const usuario = await factory.create('Usuario')

      const resposta = await request
        .get(`/usuario/${usuario._id}`)
        .set('Authorization', `Bearer 2139218392173201`)

      expect(resposta.status).toBe(401)
    })
  })
  describe('DELETE', () => {
    it('não deve deletar usuário de outra organização', async () => {
      const usuario = await factory.createMany('Usuario', 2)

      const resposta = await request
        .delete(`/usuario/${usuario[1]._id}`)
        .set(
          'Authorization',
          `Bearer ${Usuario('*').generateToken(usuario[0])}`
        )

      expect(resposta.body.deletedCount).toBe(0)
    })

    it('deve ser possível deletar usuário se token é válido', async () => {
      const usuario = await factory.create('Usuario')

      const resposta = await request
        .delete(`/usuario/${usuario._id}`)
        .set('Authorization', `Bearer ${Usuario('*').generateToken(usuario)}`)

      expect(resposta.status).toBe(200)
    })

    it('não deve ser possível deletar usuário se token é inválido', async () => {
      const usuario = await factory.create('Usuario')

      const resposta = await request
        .delete(`/usuario/${usuario._id}`)
        .set('Authorization', `Bearer 2139218392173201`)

      expect(resposta.status).toBe(401)
    })
  })
})
