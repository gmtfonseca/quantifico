const express = require('express')
const asyncHandler = require('express-async-handler')
const validate = require('express-validation')

const SessaoValidator = require('../app/validators/Sessao')
const SessaoController = require('../app/controllers/SessaoController')

const routes = express.Router()

routes.post(
  '/sessao',
  validate(SessaoValidator),
  asyncHandler(SessaoController.store)
)

module.exports = routes
