import 'package:flutter_test/flutter_test.dart';
import 'package:moneyhub_mobile/services/money_formatter.dart';

void main() {
  group('formatBRL', () {
    test('formata zero', () {
      expect(formatBRL(0), 'R\$ 0,00');
    });

    test('formata centavos com dois dígitos', () {
      expect(formatBRL(5), 'R\$ 0,05');
      expect(formatBRL(1990), 'R\$ 19,90');
    });

    test('usa ponto como separador de milhar', () {
      expect(formatBRL(123456), 'R\$ 1.234,56');
      expect(formatBRL(123456789), 'R\$ 1.234.567,89');
    });

    test('formata valores negativos', () {
      expect(formatBRL(-150000), '-R\$ 1.500,00');
    });
  });

  group('parseAmountToCents', () {
    test('aceita formato brasileiro', () {
      expect(parseAmountToCents('1.234,56'), 123456);
      expect(parseAmountToCents('12,5'), 1250);
    });

    test('aceita prefixo R\$ e espaços', () {
      expect(parseAmountToCents(' R\$ 10 '), 1000);
    });

    test('aceita ponto decimal quando não há vírgula', () {
      expect(parseAmountToCents('12.50'), 1250);
    });

    test('rejeita valores inválidos, vazios, zero ou negativos', () {
      expect(parseAmountToCents(null), isNull);
      expect(parseAmountToCents(''), isNull);
      expect(parseAmountToCents('abc'), isNull);
      expect(parseAmountToCents('0'), isNull);
      expect(parseAmountToCents('-5'), isNull);
    });
  });

  group('formatDate', () {
    test('formata como dd/MM/aaaa', () {
      expect(formatDate(DateTime(2026, 9, 5)), '05/09/2026');
    });
  });
}
