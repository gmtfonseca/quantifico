const express = require('express')
const SyncNfsController = require('../app/controllers/SyncNfsController')
const authMiddleware = require('../app/middlewares/auth')
const asyncHandler = require('express-async-handler')

const routes = express.Router()

routes.post('/sync/nfs', authMiddleware, asyncHandler(SyncNfsController.store))
routes.delete('/sync/nfs', authMiddleware, asyncHandler(SyncNfsController.destroy))

module.exports = routes
