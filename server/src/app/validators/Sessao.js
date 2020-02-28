const Joi = require('joi')
const ErrorUtil = require('../modules/utils/ErrorUtil')

module.exports = {
  body: {
    email: Joi.string()
      .email()
      .required()
      .label('Email')
      .error(ErrorUtil.joiErrorHandler),
    senha: Joi.string()
      .required()
      .label('Senha')
      .error(ErrorUtil.joiErrorHandler)
  }
}
