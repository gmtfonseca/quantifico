const server = require('./server')
const porta = process.env.PORT || 3000

server.listen(porta, err => {
  if (err) throw err

  console.log(`Servidor ligado na porta ${porta}`)
})
