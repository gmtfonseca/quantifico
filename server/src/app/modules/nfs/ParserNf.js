const atributosNf = require('../../../config/atributosNf')

function processaTag (json, tagNfAtributos) {
  let camposUtilizados = {}
  let camposNaoUtilizados = {}

  if (tagNfAtributos.tipo === 'array') {
    camposUtilizados = []
    camposNaoUtilizados = []

    let jsonArray = []

    if (Array.isArray(json)) {
      jsonArray = json
    } else {
      jsonArray.push(json)
    }

    jsonArray.map(objetoArray => {
      const {
        camposUtilizados: utilizados,
        camposNaoUtilizados: naoUtilizados
      } = processaCampos(objetoArray, tagNfAtributos.campos)

      camposUtilizados.push({ ...utilizados })
      camposNaoUtilizados.push({ ...naoUtilizados })
    })
  } else {
    const {
      camposUtilizados: utilizados,
      camposNaoUtilizados: naoUtilizados
    } = processaCampos(json, tagNfAtributos.campos)

    camposUtilizados = utilizados
    camposNaoUtilizados = naoUtilizados
  }

  // Se tag será objeto no banco, coloca infos dentro de um objeto com este nome
  if (tagNfAtributos.objeto) {
    camposUtilizados = { [tagNfAtributos.objeto]: camposUtilizados }
  }

  // Para campos não utilizados, coloca valores dentro de objeto com o nome da tag
  return { camposUtilizados, [tagNfAtributos.tag]: camposNaoUtilizados }
}

function processaCampos (objetoNf, campos) {
  let camposParaDesestruturar = []
  let camposUtilizados = {}
  let camposNaoUtilizados = {}

  if (objetoNf) {
    campos.map((campo, index, arrayProcessados) => {
      if (campo.objeto) {
        // Caso campo for um objeto com mais campos processa campos novamente
        if (campo.objeto.campos) {
          let { camposUtilizados: camposUtilizadosObjeto } = processaCampos(
            objetoNf[campo.nomeNf],
            campo.objeto.campos
          )

          if (campo.nomeBanco) {
            camposUtilizados = {
              [campo.nomeBanco]: camposUtilizadosObjeto,
              ...camposUtilizados
            }
          } else {
            camposUtilizados = {
              ...camposUtilizadosObjeto,
              ...camposUtilizados
            }
          }
        } else {
          // Caso for um objeto sem campos busca valor do campo
          const { camposUtilizados: utilizados } = desestruturaCampos(
            objetoNf,
            campo
          )

          // Verifica se ultimo campo processado deve pertencer ao mesmo objeto
          if (arrayProcessados[index - 1].objeto === campo.objeto) {
            camposUtilizados[campo.objeto] = {
              ...camposUtilizados[campo.objeto],
              ...utilizados
            }
          } else {
            camposUtilizados = {
              [campo.objeto]: { ...utilizados },
              ...camposUtilizados
            }
          }
        }
      } else {
        camposParaDesestruturar.push(campo)
      }
    })
  }

  const {
    camposUtilizados: utilizados,
    camposNaoUtilizados: naoUtililizados
  } = desestruturaCampos(objetoNf, ...camposParaDesestruturar)

  camposUtilizados = { ...utilizados, ...camposUtilizados }
  camposNaoUtilizados = { ...naoUtililizados, ...camposNaoUtilizados }

  // Se campo é um objeto, coloca infos dentro de um objeto com este nome
  if (campos.objeto) {
    camposUtilizados = { [campos.nomeBanco]: camposUtilizados }
  }

  return { camposUtilizados, camposNaoUtilizados }
}

function desestruturaCampos (objetoNf, ...campos) {
  // Esse reduce retorna apenas os campos que queremos do objeto
  const camposUtilizados = campos.reduce((anterior, atual) => {
    if (!objetoNf) {
      return {
        ...anterior,
        [atual.nomeBanco]: null
      }
    }

    let valorCampo = ''

    if (Array.isArray(atual.nomeNf)) {
      atual.nomeNf.map(nomeCampo => {
        if (!valorCampo) {
          valorCampo = nomeCampo in objetoNf ? objetoNf[nomeCampo] : null
        }
      })
    } else {
      valorCampo = atual.nomeNf in objetoNf ? objetoNf[atual.nomeNf] : null
    }

    const camposValores = {
      ...anterior,
      [atual.nomeBanco]: valorCampo
    }

    // Deleta objeto que foi utilizado para não ficar no objeto camposNaoUtilizados
    delete objetoNf[atual.nomeNf]
    return camposValores
  }, {})

  return { camposUtilizados, camposNaoUtilizados: { ...objetoNf } }
}

function buscaObjetoTagComum (json) {
  for (const key in json) {
    if (key === 'infNFe') {
      return json[key]
    }

    if (typeof json[key] === 'object' && key !== 'infNFe') {
      return buscaObjetoTagComum(json[key])
    }
  }
}

function buscaVersaoNota (json) {
  const stringNf = JSON.stringify(json)
  const posVersao = stringNf.indexOf('versao') + 8
  const versao = stringNf.substr(posVersao, 6)

  if (versao.includes('1.')) {
    return '1.0'
  }

  if (versao.includes('2.')) {
    return '2.0'
  }

  if (versao.includes('3.')) {
    return '3.0'
  }

  if (versao.includes('4.')) {
    return '4.0'
  }
}

class ParserNf {
  static async parse (json) {
    const versao = buscaVersaoNota(json)
    const atributos = atributosNf.buscaAtributosNf(versao)
    let dadosNf = await buscaObjetoTagComum(json)

    let nfCamposUtilizados = {}
    let nfCamposNaoUtilizados = {}

    atributos.map(atributos => {
      const { camposUtilizados, ...camposNaoUtilizados } = processaTag(
        dadosNf[atributos.tag],
        atributos
      )

      nfCamposUtilizados = { ...nfCamposUtilizados, ...camposUtilizados }
      nfCamposNaoUtilizados = {
        ...nfCamposNaoUtilizados,
        ...camposNaoUtilizados
      }

      delete dadosNf[atributos.tag]
    })

    const nfProcessada = {
      ...nfCamposUtilizados,
      dadosAdicionais: {
        versao,
        naoUtilizados: {
          NFe: {
            infNFe: {
              ...nfCamposNaoUtilizados,
              ...dadosNf
            }
          }
        }
      }
    }

    return nfProcessada
  }
}

module.exports = ParserNf
