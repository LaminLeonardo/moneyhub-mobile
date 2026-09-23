import '../models/transaction.dart';

/// Consolida uma lista de lançamentos em totais.
class FinanceSummary {
  FinanceSummary(Iterable<Transaction> transactions) {
    for (final t in transactions) {
      if (t.isIncome) {
        _totalIncome += t.amountInCents;
      } else {
        _totalExpense += t.amountInCents;
        _expensesByCategory.update(
          t.category,
          (value) => value + t.amountInCents,
          ifAbsent: () => t.amountInCents,
        );
      }
    }
  }

  int _totalIncome = 0;
  int _totalExpense = 0;
  final Map<String, int> _expensesByCategory = {};

  int get totalIncome => _totalIncome;
  int get totalExpense => _totalExpense;
  int get balance => _totalIncome - _totalExpense;

  Map<String, int> get expensesByCategory =>
      Map.unmodifiable(_expensesByCategory);
}
