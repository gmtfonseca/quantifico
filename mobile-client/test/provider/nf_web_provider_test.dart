import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/data/model/nf/customer.dart';
import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';
import 'package:quantifico/data/model/nf/product.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';

import '../mocks.dart';

void main() {
  group('Nf Web Provider', () {
    final webClient = MockWebClient();
    final tokenLocalProvider = MockTokenLocalProvider();
    final nfWebProvider = NfWebProvider(
      webClient: webClient,
      tokenLocalProvider: tokenLocalProvider,
    );

    test('should fetch Nfs properly', () async {
      when(
        webClient.fetch(
          'nfs',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) => Future<dynamic>.value(
          {
            'docs': [
              {
                'dataEmissaoDecomposta': {'dia': 13, 'mes': 5, 'ano': 2019},
                'cliente': {
                  'endereco': {
                    'municipio': {'codigo': 3106200, 'descricao': 'BELO HORIZONTE'},
                    'pais': {'codigo': 1058, 'descricao': 'BRASIL'},
                    'logradouro': 'RUA ALAGOAS',
                    'numero': '1314',
                    'cep': '30130160',
                    'uf': 'MG'
                  },
                  'cnpj': '25909664000103',
                  'razaoSocial': 'POLLU COM. E REPRESENTACOES LTDA'
                },
                'total': {'nf': 449, 'produtos': 449, 'desconto': 0, 'frete': 0},
                'arquivo': {
                  'nome': '3429.XML',
                  'dataModificacao': '2019-05-13T11:53:06.000Z',
                  'estado': '3429.XML/1557755586'
                },
                'saidas': [
                  {
                    'produto': {'codigo': 'PG001051', 'descricao': 'GALO DOIDO', 'ean': 'SEM GTIN', 'ncm': 44201000},
                    'valor': {'unitario': 1, 'total': 149, 'frete': null, 'desconto': null, 'outro': null},
                    '_id': '5de6f579f279263b48babee5',
                    'quantidade': 149,
                    'cfop': 6101,
                    'nfs': '5de6f578f279263b48babeb8',
                    'organizacao': '5de6f241f279263b48ba5f2a',
                    '__v': 0
                  },
                  {
                    'produto': {'codigo': 'PG001052', 'descricao': 'GALO MALUCO', 'ean': 'SEM GTIN', 'ncm': 44201000},
                    'valor': {'unitario': 2, 'total': 300, 'frete': null, 'desconto': null, 'outro': null},
                    '_id': '5de6f579f279263b48babee5',
                    'quantidade': 150,
                    'cfop': 6101,
                    'nfs': '5de6f578f279263b48babeb8',
                    'organizacao': '5de6f241f279263b48ba5f2a',
                    '__v': 0
                  }
                ],
                '_id': '5de6f578f279263b48babeb8',
                'idSefaz': '13051052',
                'serie': '1',
                'numero': 3429,
                'naturezaOperacao': 'VENDA',
                'localDestino': 2,
                'tipoAmbiente': 1,
                'finalidadeEmissao': 1,
                'dataEmissao': '2019-05-13T13:52:50.000Z',
                'organizacao': '5de6f241f279263b48ba5f2a',
              },
              {
                'dataEmissaoDecomposta': {'dia': 10, 'mes': 5, 'ano': 2019},
                'cliente': {
                  'endereco': {
                    'municipio': {'codigo': 4305108, 'descricao': 'CAXIAS DO SUL'},
                    'pais': {'codigo': 1058, 'descricao': 'BRASIL'},
                    'logradouro': 'RUA PEDRO GIACOMET',
                    'numero': '2546',
                    'cep': '95076350',
                    'uf': 'RS'
                  },
                  'cnpj': '87395844000162',
                  'razaoSocial': 'RAKALO PRODUTOS DE BELEZA LTDA'
                },
                'total': {'nf': 1953.11, 'produtos': 1650.6, 'desconto': 0, 'frete': 0},
                'arquivo': {
                  'nome': '3428.XML',
                  'dataModificacao': '2019-05-10T15:46:00.000Z',
                  'estado': '3428.XML/1557510360'
                },
                'saidas': [
                  {
                    'produto': {'codigo': '114', 'descricao': 'PENTE REF 114', 'ean': 'SEM GTIN', 'ncm': 96151900},
                    'valor': {'unitario': 180, 'total': 1650.6, 'frete': null, 'desconto': null, 'outro': null},
                    '_id': '5de6f31ff279263b48ba6b11',
                    'quantidade': 9.17,
                    'cfop': 5401,
                    'nfs': '5de6f31ff279263b48ba6aeb',
                    'organizacao': '5de6f241f279263b48ba5f2a',
                    '__v': 0
                  }
                ],
                '_id': '5de6f31ff279263b48ba6aeb',
                'idSefaz': '10051445',
                'serie': '1',
                'numero': 3428,
                'naturezaOperacao': 'VENDA DE MERCADORIA SUJEITA A SUBST. TRIB.',
                'localDestino': 1,
                'tipoAmbiente': 1,
                'finalidadeEmissao': 1,
                'dataEmissao': '2019-05-10T17:45:51.000Z',
                'organizacao': '5de6f241f279263b48ba5f2a',
              },
            ],
          },
        ),
      );
      final nf1 = Nf(
        series: '1',
        number: 3429,
        date: DateTime.parse('2019-05-13T13:52:50.000Z'),
        totalAmount: 449,
        customer: const Customer(
          cnpj: '25909664000103',
          name: 'POLLU COM. E REPRESENTACOES LTDA',
        ),
        items: const [
          NfItem(
            product: Product(
              code: 'PG001051',
              description: 'GALO DOIDO',
            ),
            unitPrice: 1.0,
            totalAmount: 149.0,
            quantity: 149,
          ),
          NfItem(
            product: Product(
              code: 'PG001052',
              description: 'GALO MALUCO',
            ),
            unitPrice: 2.0,
            totalAmount: 300.0,
            quantity: 150,
          ),
        ],
      );

      final nf2 = Nf(
        series: '1',
        number: 3428,
        date: DateTime.parse('2019-05-10T17:45:51.000Z'),
        totalAmount: 1953.11,
        customer: const Customer(
          cnpj: '87395844000162',
          name: 'RAKALO PRODUTOS DE BELEZA LTDA',
        ),
        items: const [
          NfItem(
            product: Product(
              code: '114',
              description: 'PENTE REF 114',
            ),
            unitPrice: 180.0,
            totalAmount: 1650.6,
            quantity: 9.17,
          ),
        ],
      );

      final data = await nfWebProvider.fetchNfs();
      expect(data, [
        nf1,
        nf2,
      ]);
    });

    test('should fetch monthly sales properly', () async {
      when(webClient.fetch(
        'nfs/stats',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) => Future<dynamic>.value(
          {'totalNf': '100', 'totalFaturado': 3000.50},
        ),
      );
      final data = await nfWebProvider.fetchStats();
      expect(
        data,
        const NfStats(nfCount: 100, totalSales: 3000.50),
      );
    });
  });
}
