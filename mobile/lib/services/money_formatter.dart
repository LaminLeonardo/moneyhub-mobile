/// Formata um valor em centavos no padrão brasileiro: R$ 1.234,56
String formatBRL(int cents) {
  final negative = cents < 0;
  final abs = cents.abs();
  final reais = abs ~/ 100;
  final centavos = (abs % 100).toString().padLeft(2, '0');

  final digits = reais.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${negative ? '-' : ''}R\$ $buffer,$centavos';
}

/// Converte o texto digitado pelo usuário (ex.: "1.234,56", "12,5",
/// "R$ 10") em centavos. Retorna null se o valor for inválido ou <= 0.
int? parseAmountToCents(String? input) {
  if (input == null) return null;
  var text = input.replaceAll('R\$', '').replaceAll(' ', '').trim();
  if (text.isEmpty) return null;

  if (text.contains(',')) {
    text = text.replaceAll('.', '').replaceAll(',', '.');
  }

  final value = double.tryParse(text);
  if (value == null || value <= 0) return null;
  return (value * 100).round();
}

/// Formata a data como dd/MM/aaaa.
String formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d/$m/${date.year}';
}
