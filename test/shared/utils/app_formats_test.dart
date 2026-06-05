import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/shared/utils/app_formats.dart';

const _nb = ' ';

void main() {
  group('currencyFormat', () {
    test('formata valor inteiro', () {
      expect(currencyFormat.format(53.00), 'R\$${_nb}53,00');
    });

    test('formata valor com decimais', () {
      expect(currencyFormat.format(1234.50), 'R\$${_nb}1.234,50');
    });

    test('formata zero', () {
      expect(currencyFormat.format(0), 'R\$${_nb}0,00');
    });
  });
}
