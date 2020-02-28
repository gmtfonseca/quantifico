module.exports = [
  // Informações que devem ser extraidas da tag <ide>
  {
    tag: 'ide',
    campos: [
      { nomeNf: 'cNF', nomeBanco: 'idSefaz' },
      { nomeNf: 'serie', nomeBanco: 'serie' },
      { nomeNf: 'nNF', nomeBanco: 'numero' },
      { nomeNf: 'natOp', nomeBanco: 'naturezaOperacao' },
      { nomeNf: 'tpAmb', nomeBanco: 'tipoAmbiente' },
      { nomeNf: 'finNFe', nomeBanco: 'finalidadeEmissao' },
      { nomeNf: 'dhEmi', nomeBanco: 'dataEmissao' }
    ]
  },

  // Informações que devem ser extraidas da tag <dest>
  {
    tag: 'dest',
    objeto: 'cliente',
    campos: [
      { nomeNf: ['CNPJ', 'CPF'], nomeBanco: 'cnpj' },
      { nomeNf: 'xNome', nomeBanco: 'razaoSocial' },
      {
        nomeNf: 'enderDest',
        nomeBanco: 'endereco',
        objeto: {
          campos: [
            { nomeNf: 'xLgr', nomeBanco: 'logradouro' },
            { nomeNf: 'nro', nomeBanco: 'numero' },
            { nomeNf: 'CEP', nomeBanco: 'cep' },
            { nomeNf: 'UF', nomeBanco: 'uf' },
            { nomeNf: 'cMun', nomeBanco: 'codigo', objeto: 'municipio' },
            { nomeNf: 'xMun', nomeBanco: 'descricao', objeto: 'municipio' },
            { nomeNf: 'cPais', nomeBanco: 'codigo', objeto: 'pais' },
            { nomeNf: 'xPais', nomeBanco: 'descricao', objeto: 'pais' }
          ]
        }
      }
    ]
  },

  // Informações que devem ser extraidas da tag <total>
  {
    tag: 'total',
    campos: [
      {
        nomeNf: 'ICMSTot',
        nomeBanco: 'total',
        objeto: {
          campos: [
            { nomeNf: 'vNF', nomeBanco: 'nf' },
            { nomeNf: 'vProd', nomeBanco: 'produtos' },
            { nomeNf: 'vDesc', nomeBanco: 'desconto' },
            { nomeNf: 'vFrete', nomeBanco: 'frete' }
          ]
        }
      }
    ]
  },

  // Informações que devem ser extraidas da tag <det>
  {
    tag: 'det',
    tipo: 'array',
    objeto: 'saidas',
    campos: [
      {
        nomeNf: 'prod',
        objeto: {
          campos: [
            { nomeNf: 'vUnCom', nomeBanco: 'quantidade' },
            { nomeNf: 'CFOP', nomeBanco: 'cfop' },
            { nomeNf: 'qCom', nomeBanco: 'unitario', objeto: 'valor' },
            { nomeNf: 'vProd', nomeBanco: 'total', objeto: 'valor' },
            { nomeNf: 'vFrete', nomeBanco: 'frete', objeto: 'valor' },
            { nomeNf: 'vDesc', nomeBanco: 'desconto', objeto: 'valor' },
            { nomeNf: 'vOutro', nomeBanco: 'outro', objeto: 'valor' },
            { nomeNf: 'cProd', nomeBanco: 'codigo', objeto: 'produto' },
            { nomeNf: 'xProd', nomeBanco: 'descricao', objeto: 'produto' },
            { nomeNf: 'cEAN', nomeBanco: 'ean', objeto: 'produto' },
            { nomeNf: 'NCM', nomeBanco: 'ncm', objeto: 'produto' }
          ]
        }
      },
      {
        nomeNf: 'imposto',
        nomeBanco: 'imposto',
        objeto: {
          campos: [
            {
              nomeNf: 'ICMS',
              nomeBanco: 'icms',
              objeto: {
                campos: [
                  {
                    nomeNf: 'ICMSSN500',
                    objeto: {
                      campos: [
                        { nomeNf: 'pCredSN', nomeBanco: 'percentual' },
                        { nomeNf: 'vCredICMSSN', nomeBanco: 'valor' }
                      ]
                    }
                  }
                ]
              }
            },
            {
              nomeNf: 'PIS',
              nomeBanco: 'pis',
              objeto: {
                campos: [
                  {
                    nomeNf: 'PISOutr',
                    objeto: {
                      campos: [
                        { nomeNf: 'pPIS', nomeBanco: 'percentual' },
                        { nomeNf: 'vPIS', nomeBanco: 'valor' }
                      ]
                    }
                  }
                ]
              }
            },
            {
              nomeNf: 'COFINS',
              nomeBanco: 'cofins',
              objeto: {
                campos: [
                  {
                    nomeNf: 'COFINSOutr',
                    objeto: {
                      campos: [
                        { nomeNf: 'pCOFINS', nomeBanco: 'percentual' },
                        { nomeNf: 'vCOFINS', nomeBanco: 'valor' }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    ]
  }
]
