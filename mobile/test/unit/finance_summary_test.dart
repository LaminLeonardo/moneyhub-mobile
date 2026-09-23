import 'package:flutter_test/flutter_test.dart';
import 'package:moneyhub_mobile/models/transaction.dart';
import 'package:moneyhub_mobile/services/finance_summary.dart';

Transaction _t(String id, int cents, TransactionType type, String category) {
  return Transaction(
    id: id,
    description: 'Lançamento $id',
    amountInCents: cents,
    type: type,
    category: category,
    date: DateTime(2026, 9, 1),
  );
}

void main() {
  test('lista vazia gera totais zerados', () {
    final summary = FinanceSummary([]);
    expect(summary.totalIncome, 0);
    expect(summary.totalExpense, 0);
    expect(summary.balance, 0);
    expect(summary.expensesByCategory, isEmpty);
  });

  test('calcula receitas, despesas e saldo', () {
    final summary = FinanceSummary([
      _t('1', 500000, TransactionType.income, 'Trabalho'),
      _t('2', 150000, TransactionType.expense, 'Moradia'),
      _t('3', 20000, TransactionType.expense, 'Alimentação'),
    ]);

    expect(summary.totalIncome, 500000);
    expect(summary.totalExpense, 170000);
    expect(summary.balance, 330000);
  });

  test('agrupa despesas por categoria', () {
    final summary = FinanceSummary([
      _t('1', 1000, TransactionType.expense, 'Alimentação'),
      _t('2', 2500, TransactionType.expense, 'Alimentação'),
      _t('3', 4000, TransactionType.expense, 'Transporte'),
      _t('4', 9999, TransactionType.income, 'Trabalho'),
    ]);

    expect(summary.expensesByCategory, {
      'Alimentação': 3500,
      'Transporte': 4000,
    });
  });

  test('valor com sinal depende do tipo', () {
    expect(_t('1', 100, TransactionType.income, 'X').signedAmountInCents, 100);
    expect(
      _t('2', 100, TransactionType.expense, 'X').signedAmountInCents,
      -100,
    );
  });
}
