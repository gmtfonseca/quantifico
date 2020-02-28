const jwt = require('jsonwebtoken')
const authConfig = require('../../config/auth')
const HttpStatus = require('http-status-codes')
const ErrorUtil = require('../modules/utils/ErrorUtil')

module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization

  if (!authHeader) {
    return ErrorUtil.returnError(
      res,
      HttpStatus.UNAUTHORIZED,
      'Token não inforamdo'
    )
  }

  try {
    const token = authHeader.replace('Bearer ', '')
    // Verifica se o token informado é válido
    const decoded = jwt.verify(token, authConfig.secret)

    req.usuarioId = decoded.id
    req.organizacaoId = decoded.organizacao

    return next()
  } catch (err) {
    return ErrorUtil.returnError(res, HttpStatus.UNAUTHORIZED, 'Token inválido')
  }
}
