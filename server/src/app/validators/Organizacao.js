const Joi = require('joi')
const ErrorUtil = require('../modules/utils/ErrorUtil')

module.exports = {
  body: {
    cnpj: Joi.string()
      .required()
      .label('CNPJ')
      .error(ErrorUtil.joiErrorHandler),
    razaoSocial: Joi.string()
      .required()
      .label('Razão social')
      .error(ErrorUtil.joiErrorHandler)
  }
}
