const supertest = require('supertest')
const app = require('../../src/server')
const database = require('../util/database')
const { factory } = require('../util/factories')
const {
  UsuarioByOrganizacao: Usuario
} = require('../../src/app/models/Usuario')

const request = supertest(app)

describe('Nfs /nfs', () => {
  beforeAll(database.abreConexao)
  afterAll(database.fechaConexao)

  describe('GET', () => {
    it('não deve consultar nfs de outra organização', async () => {
      const usuario = await factory.createMany('Usuario', 2)

      const nfUsuario1 = await factory.create('Nfs', {
        organizacao: usuario[1].organizacao
      })

      const resposta = await request
        .get(`/nfs/${nfUsuario1._id}`)
        .set(
          'Authorization',
          `Bearer ${Usuario('*').generateToken(usuario[0])}`
        )

      expect(resposta.body).toBe(null)
    })

    it('deve ser possível consultar nfs se token é válido', async () => {
      const usuario = await factory.create('Usuario')

      const nf = await factory.create('Nfs', {
        organizacao: usuario.organizacao
      })

      const resposta = await request
        .get(`/nfs/${nf._id}`)
        .set('Authorization', `Bearer ${Usuario('*').generateToken(usuario)}`)

      expect(resposta.status).toBe(200)
    })

    it('não deve ser possível consultar usuário se token é inválido', async () => {
      // const usuario = await factory.create('Usuario')
      const nf = await factory.create('Nfs')

      const resposta = await request
        .get(`/nfs/${nf._id}`)
        .set('Authorization', `Bearer 2139218392173201`)

      expect(resposta.status).toBe(401)
    })
  })
  describe('DELETE', () => {
    it('não deve deletar nfs de outra organização', async () => {
      const usuario = await factory.createMany('Usuario', 2)

      const nfUsuario1 = await factory.create('Nfs', {
        organizacao: usuario[1].organizacao
      })

      const resposta = await request
        .delete(`/nfs/${nfUsuario1._id}`)
        .set(
          'Authorization',
          `Bearer ${Usuario('*').generateToken(usuario[0])}`
        )

      expect(resposta.body).toBe(null)
    })

    it('deve ser possível deletar nfs se token é válido', async () => {
      const usuario = await factory.create('Usuario')

      const nf = await factory.create('Nfs', {
        organizacao: usuario.organizacao
      })

      const resposta = await request
        .delete(`/nfs/${nf._id}`)
        .set('Authorization', `Bearer ${Usuario('*').generateToken(usuario)}`)

      expect(resposta.status).toBe(200)
    })

    it('não deve ser possível deletar nfs se token é inválido', async () => {
      const usuario = await factory.create('Usuario')

      const nf = await factory.create('Nfs', {
        organizacao: usuario.organizacao
      })

      const resposta = await request
        .delete(`/nfs/${nf._id}`)
        .set('Authorization', `Bearer 2139218392173201`)

      expect(resposta.status).toBe(401)
    })
  })
})
