module.exports = {
  uri:
    process.env.NODE_ENV === 'prod'
      ? process.env.DB_URL
      : process.env.NODE_ENV === 'test'
        ? process.env.DB_URL_TESTE
        : process.env.DB_URL_DESENVOLVIMENTO
}
