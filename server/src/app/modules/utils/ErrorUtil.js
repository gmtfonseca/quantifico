class ErrorUtil {
  // Template e retorno de erros
  static returnError (res, httpCode, message) {
    const errorTemplate = {
      errors: [
        {
          messages: [message]
        }
      ]
    }

    return res.status(httpCode).json(errorTemplate)
  }

  // Handler para tratamento dos erros do joi
  static joiErrorHandler (errors) {
    errors.forEach(err => {
      switch (err.type) {
        case 'any.empty':
          err.message = `O campo ${err.context.label} deve ser informado.`
          break
        case 'any.required':
          err.message = `O campo ${err.context.label} é obrigatório.`
          break
        case 'string.email':
          err.message = `${err.context.label} inválido.`
          break
        case 'string.min':
          err.message = `${err.context.label} deve ter no mínimo X caracteres.`
          break
        case 'string.max':
          err.message = `${err.context.label} deve ter no máximo X caracteres.`
          break
        case 'string.base':
          err.message = `${err.context.label} deve ser uma string.`
          break
        case 'number.base':
          err.message = `${err.context.label} deve conter apenas caracteres númericos.`
          break
        default:
          break
      }
    })
    return errors
  }
}

module.exports = ErrorUtil
