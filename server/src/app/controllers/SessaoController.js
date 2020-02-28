const { UsuarioByOrganizacao: Usuario } = require('../models/Usuario')
const HttpStatus = require('http-status-codes')
const ErrorUtil = require('../modules/utils/ErrorUtil')

class SessionController {
  async store (req, res) {
    const { email, senha } = req.body

    const usuario = await Usuario('*').findOne({ email })

    if (!usuario) {
      return ErrorUtil.returnError(
        res,
        HttpStatus.UNAUTHORIZED,
        'Usuário não encontrado.'
      )
    }

    if (!(await usuario.comparePasswordHash(senha))) {
      return ErrorUtil.returnError(
        res,
        HttpStatus.UNAUTHORIZED,
        'Senha inválida.'
      )
    }

    return res.json({ usuario, token: Usuario('*').generateToken(usuario) })
  }
}

module.exports = new SessionController()
