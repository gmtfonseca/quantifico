const express = require('express')
const asyncHandler = require('express-async-handler')
const validate = require('express-validation')

const OrganizacaoController = require('../app/controllers/OrganizacaoController')
const OrganizacaoValidator = require('../app/validators/Organizacao')
const authMiddleware = require('../app/middlewares/auth')

const routes = express.Router()

routes.post(
  '/organizacao',
  validate(OrganizacaoValidator),
  asyncHandler(OrganizacaoController.store)
)
routes.get(
  '/organizacao/:id',
  authMiddleware,
  asyncHandler(OrganizacaoController.show)
)

routes.put(
  '/organizacao/:id',
  authMiddleware,
  asyncHandler(OrganizacaoController.update)
)

module.exports = routes
