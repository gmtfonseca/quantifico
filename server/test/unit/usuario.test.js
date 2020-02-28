const bcrypt = require('bcryptjs')
const { factory } = require('../util/factories')
const database = require('../util/database')

describe('Usuário (unitários)', () => {
  beforeAll(database.abreConexao)
  afterAll(database.fechaConexao)

  it('deve criptografar password', async () => {
    const usuario = await factory.create('Usuario', {
      senha: '1234567'
    })

    const hashIgual = await bcrypt.compare('1234567', usuario.senha)

    expect(hashIgual).toBe(true)
  })
})
