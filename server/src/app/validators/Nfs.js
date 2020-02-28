const Joi = require('joi')
const ErrorUtil = require('../modules/utils/ErrorUtil')

module.exports = {
  body: {
    idSefaz: Joi.string()
      .required()
      .error(ErrorUtil.joiErrorHandler),
    serie: Joi.string()
      .required()
      .error(ErrorUtil.joiErrorHandler),
    numero: Joi.number()
      .required()
      .error(ErrorUtil.joiErrorHandler),
    naturezaOperacao: Joi.string()
      .required()
      .error(ErrorUtil.joiErrorHandler),
    cliente: {
      cnpj: Joi.string()
        .required()
        .error(ErrorUtil.joiErrorHandler),
      razaoSocial: Joi.string()
        .required()
        .error(ErrorUtil.joiErrorHandler)
    }
  }
}
