module.exports = (organizacao, mongooseModel) => {
  const modelo = mongooseModel

  if (organizacao === '*') {
    return modelo
  } else if (organizacao) {
    return modelo.byOrganizacao(organizacao)
  } else {
    throw Error('Organização não definida')
  }
}
