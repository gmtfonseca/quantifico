const express = require('express')
const asyncHandler = require('express-async-handler')
const validate = require('express-validation')

const UsuarioValidator = require('../app/validators/Usuario')
const UsuarioController = require('../app/controllers/UsuarioController')
const authMiddleware = require('../app/middlewares/auth')

const routes = express.Router()

routes.post(
  '/usuario',
  validate(UsuarioValidator),
  asyncHandler(UsuarioController.store)
)
routes.get('/usuario', authMiddleware, asyncHandler(UsuarioController.index))
routes.get('/usuario/:id', authMiddleware, asyncHandler(UsuarioController.show))
routes.delete(
  '/usuario/:id',
  authMiddleware,
  asyncHandler(UsuarioController.destroy)
)

module.exports = routes
