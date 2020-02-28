const Joi = require('joi')
const ErrorUtil = require('../modules/utils/ErrorUtil')

module.exports = {
  body: {
    nome: Joi.string()
      .required()
      .label('Nome')
      .error(ErrorUtil.joiErrorHandler),
    email: Joi.string()
      .email()
      .required()
      .label('E-mail')
      .error(ErrorUtil.joiErrorHandler),
    senha: Joi.string()
      .required()
      .min(6)
      .label('Senha')
      .error(ErrorUtil.joiErrorHandler),
    organizacao: Joi.required().error(ErrorUtil.joiErrorHandler)
  }
}
