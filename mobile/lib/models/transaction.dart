enum TransactionType { income, expense }

/// Lançamento financeiro. Valores são guardados em centavos (int)
/// para evitar erros de arredondamento de ponto flutuante.
class Transaction {
  const Transaction({
    required this.id,
    required this.description,
    required this.amountInCents,
    required this.type,
    required this.category,
    required this.date,
  }) : assert(amountInCents > 0, 'O valor deve ser positivo');

  final String id;
  final String description;
  final int amountInCents;
  final TransactionType type;
  final String category;
  final DateTime date;

  bool get isIncome => type == TransactionType.income;

  /// Valor com sinal: positivo para receitas, negativo para despesas.
  int get signedAmountInCents => isIncome ? amountInCents : -amountInCents;
}
