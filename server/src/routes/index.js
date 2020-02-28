const express = require('express')
const usuarioRoute = require('./usuarioRoute')
const sessaoRoute = require('./sessaoRoute')
const nfsRoute = require('./nfsRoute')
const syncNfsRoute = require('./syncNfsRoute')
const organizacaoRoute = require('./organizacaoRoute')

const routes = express.Router()
routes.use(usuarioRoute)
routes.use(sessaoRoute)
routes.use(nfsRoute)
routes.use(syncNfsRoute)
routes.use(organizacaoRoute)

module.exports = routes
