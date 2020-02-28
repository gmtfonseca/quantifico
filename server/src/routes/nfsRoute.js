const express = require('express')
const asyncHandler = require('express-async-handler')
// Comentado para fazer testes com postman
// const validate = require('express-validation')
// const validadores = require('../app/validators')
const NfsController = require('../app/controllers/NfsController')
const authMiddleware = require('../app/middlewares/auth')

const routes = express.Router()

routes.get('/nfs', authMiddleware, asyncHandler(NfsController.index))
routes.get('/nfs/:id', authMiddleware, asyncHandler(NfsController.show))
routes.get(
  '/nfs/plot/:name',
  authMiddleware,
  asyncHandler(NfsController.plot)
)
routes.post(
  '/nfs',
  authMiddleware,
  // validate(validadores.Nfs),
  asyncHandler(NfsController.store)
)
routes.delete('/nfs/:id', authMiddleware, asyncHandler(NfsController.destroy))

module.exports = routes
