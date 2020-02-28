const { SaidaByOrganizacao: Saida } = require('../Saida')
const ParserNf = require('../../modules/nfs/ParserNf')
const SessaoDb = require('../../modules/database/SessaoDb')
const CompressaoUtil = require('../../modules/utils/CompressaoUtil')
const TimeUtil = require('../../modules/utils/TimeUtil')

module.exports = {
  async getSnapshot () {
    const nfsSaida = await this.find()
      .select('arquivo.estado')
      .exec()
    // Necessário pois não consegui obter somente subdocument sem informação do parent
    const snapshot = nfsSaida.map(nfs => nfs.arquivo.estado)
    return snapshot
  },

  async insereFromArquivo (arquivo) {
    let nfCriada = await this.insereFromJson(arquivo.conteudo)
    nfCriada.arquivo = {
      nome: arquivo.nome,
      dataModificacao: TimeUtil.secondsToDate(arquivo.dataModificacaoSegundos),
      estado: arquivo.getEstado()
    }
    await nfCriada.save()
    return nfCriada
  },

  async insereFromJson (json) {
    const nfProcessada = await ParserNf.parse(json)
    /*
    TODO desenvolvimento parte de atualização das notas no banco quando houver
    campos novos

    const nfAntiga = await this.findOne()
      .lean()
      .populate(['cliente'])

    if (nfAntiga && this.existeCamposDiferentes(nfAntiga, nfProcessada)) {
      this.atualizaNfs()
    } */

    const sessaoDb = new SessaoDb(this)
    await sessaoDb.iniciar()
    const nfCriada = await sessaoDb.executar(async () => {
      let { saidas, ...nf } = nfProcessada

      nf.dadosAdicionais.naoUtilizados = await CompressaoUtil.toStringBase64(
        nf.dadosAdicionais.naoUtilizados
      )
      nf = await this.create(nf)

      nf.saidas = await Saida(this.getOrganizacaoId()).insereMultiplas(
        saidas,
        nf._id
      )
      await nf.save()
      return nf
    })
    sessaoDb.finalizar()

    return nfCriada
  },

  async deletaById (id) {
    const nfs = await this.findById(id)
    if (nfs) {
      const nfsDeletada = await nfs.remove()
      return nfsDeletada._id
    } else {
      return null
    }
  },

  async deletaByArquivos (arquivos) {
    for (const arquivo of arquivos) {
      await this.deletaByArquivo(arquivo)
    }
  },

  async deletaByArquivo (nomeArquivo) {
    const nfs = await this.findOne({ 'arquivo.nome': nomeArquivo })
    if (nfs) {
      await nfs.remove()
    }
  }

  // TODO Funções para usar futuramente quando houver adição de campos
  // async atualizaNfs () {
  //   const nfs = await this.find().populate(['cliente'])

  //   nfs.forEach(async nfAntiga => {
  //     const nfProcessada = await this.processaNf(
  //       nfAntiga.dadosAdicionais,
  //       nfAntiga
  //     )
  //     try {
  //       await this.findByIdAndUpdate(nfAntiga._id, nfProcessada)
  //     } catch (error) {
  //       console.log(error)
  //     }
  //   })
  // },

  // existeCamposDiferentes (nfAntiga, nfNova) {
  //   let encontrouDiferenca = false

  //   for (const key in nfNova) {
  //     if (key !== 'dadosAdicionais') {
  //       if (typeof nfAntiga[key] !== 'undefined') {
  //         if (
  //           typeof nfNova[key] === 'object' &&
  //           typeof nfAntiga[key] === 'object'
  //         ) {
  //           encontrouDiferenca = this.existeCamposDiferentes(
  //             nfAntiga[key],
  //             nfNova[key]
  //           )
  //           if (encontrouDiferenca) {
  //             encontrouDiferenca = true
  //             break
  //           }
  //         }
  //       } else {
  //         // console.log('encontrou dif ' + key)
  //         encontrouDiferenca = true
  //         break
  //       }
  //     }
  //   }

  //   return encontrouDiferenca
  // }
}
