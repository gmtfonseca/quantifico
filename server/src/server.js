require('dotenv').config()

const express = require('express')
const mongoose = require('mongoose')
const Youch = require('youch')
const validate = require('express-validation')
const HttpStatus = require('http-status-codes')
const cors = require('cors')

const databaseConfig = require('./config/database')

class App {
  constructor () {
    this.express = express()
    this.express.use(express.json({ limit: '1mb' }))
    this.express.use(cors())
    this.server = require('http').Server(this.express)
    this.io = require('socket.io')(this.server)

    if (process.env.NODE_ENV !== 'test') {
      this.database()
      this.hooks()
    }
    this.socket()
    this.routes()
    this.exception()
  }

  hooks () {
    this.server.on('close', async function () {
      await mongoose.disconnect()
    })
  }

  async socket () {
    this.io.on('connection', socket => {
      socket.on('connectQuantifico', socketIdOrganizacao => {
        return socket.join(socketIdOrganizacao)
      })
    })

    this.express.use((req, res, next) => {
      req.io = this.io

      return next()
    })
  }

  database () {
    try {
      mongoose.connect(databaseConfig.uri, {
        useCreateIndex: true,
        useNewUrlParser: true
      })

      process.env.NODE_ENV && console.log('Conexão com db estabelecida')
    } catch (err) {
      throw err
    }
  }

  routes () {
    this.express.use(require('./routes'))
  }

  // Handler para mapear os erros que ocorrem no servidor
  exception () {
    this.express.use(async (err, req, res, next) => {
      if (err instanceof validate.ValidationError) {
        return res.status(err.status).json(err)
      }

      // Caso estiver ambiente de desenv, youch retorna um json com infos uteis
      if (['development', 'test'].includes(process.env.NODE_ENV)) {
        console.log(err)
        const youchError = new Youch(err)
        return res
          .status(err.status || HttpStatus.INTERNAL_SERVER_ERROR)
          .json(await youchError.toJSON())
      }

      return res
        .status(err.status || HttpStatus.INTERNAL_SERVER_ERROR)
        .json({ error: 'Erro no servidor' })
    })
  }
}

module.exports = new App().server
