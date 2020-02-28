class RangeQueryBuilder {
  constructor (campo) {
    this.campo = campo
  }

  build (valorInicial, valorFinal) {
    const query = {
      $match: {}
    }

    if (valorInicial && valorFinal) {
      query.$match[this.campo] = {
        $gte: valorInicial,
        $lte: valorFinal
      }
    } else if (valorInicial) {
      query.$match[this.campo] = {
        $gte: valorInicial
      }
    } else if (valorFinal) {
      query.$match[this.campo] = {
        $lte: valorFinal
      }
    }
    return query
  }
}

module.exports = RangeQueryBuilder
