import 'package:flutter_test/flutter_test.dart';
import 'package:quantifico/data/model/nf/customer.dart';
import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';
import 'package:quantifico/data/model/nf/product.dart';

void main() {
  group('Nf model', () {
    test('should parse json into model', () {
      const json = {
        'serie': '1',
        'numero': 3429,
        'dataEmissao': '2019-05-13T13:52:50.000Z',
        'total': {
          'nf': 150,
        },
        'cliente': {'cnpj': '87395844000165', 'razaoSocial': 'RAKALO PRODUTOS DE BELEZA LTDA'},
        'saidas': [
          {
            'produto': {
              'codigo': 'PG001051',
              'descricao': 'GALO DOIDO',
            },
            'valor': {
              'unitario': 2.0,
              'total': 300.0,
            },
            'quantidade': 150
          },
          {
            'produto': {
              'codigo': 'PG001052',
              'descricao': 'GALO MALUCO',
            },
            'valor': {
              'unitario': 1.0,
              'total': 150.0,
            },
            'quantidade': 150,
          }
        ]
      };
      final nf = Nf.fromJson(json);
      expect(
        nf,
        Nf(
          series: '1',
          number: 3429,
          date: DateTime.parse('2019-05-13T13:52:50.000Z'),
          totalAmount: 150,
          customer: const Customer(
            cnpj: '87395844000165',
            name: 'RAKALO PRODUTOS DE BELEZA LTDA',
          ),
          items: const [
            NfItem(
              product: Product(
                code: 'PG001051',
                description: 'GALO DOIDO',
              ),
              unitPrice: 2.0,
              totalAmount: 300.0,
              quantity: 150.0,
            ),
            NfItem(
              product: Product(
                code: 'PG001052',
                description: 'GALO MALUCO',
              ),
              unitPrice: 1.0,
              totalAmount: 150.0,
              quantity: 150.0,
            ),
          ],
        ),
      );
    });
  });
}
