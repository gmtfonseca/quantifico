module.exports = {
  secret: process.env.APP_SECRET_JWT, // Chave secreta
  ttl: 86400 // Tempo que o token é valido em ms
}
