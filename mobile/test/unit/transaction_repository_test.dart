import 'package:flutter_test/flutter_test.dart';
import 'package:moneyhub_mobile/models/transaction.dart';
import 'package:moneyhub_mobile/services/transaction_repository.dart';

Transaction _t(String id, DateTime date) {
  return Transaction(
    id: id,
    description: 'Lançamento $id',
    amountInCents: 1000,
    type: TransactionType.expense,
    category: 'Geral',
    date: date,
  );
}

void main() {
  test('retorna lançamentos do mais recente para o mais antigo', () {
    final repo = InMemoryTransactionRepository([
      _t('antigo', DateTime(2026, 1, 1)),
      _t('recente', DateTime(2026, 3, 1)),
      _t('meio', DateTime(2026, 2, 1)),
    ]);

    expect(repo.getAll().map((t) => t.id), ['recente', 'meio', 'antigo']);
  });

  test('adiciona e remove lançamentos', () {
    final repo = InMemoryTransactionRepository();
    repo.add(_t('1', DateTime(2026, 1, 1)));
    expect(repo.getAll(), hasLength(1));

    repo.remove('1');
    expect(repo.getAll(), isEmpty);
  });

  test('não permite id duplicado', () {
    final repo = InMemoryTransactionRepository([_t('1', DateTime(2026))]);
    expect(() => repo.add(_t('1', DateTime(2026))), throwsArgumentError);
  });

  test('dados de exemplo possuem receitas e despesas', () {
    final repo = InMemoryTransactionRepository.withSampleData();
    final items = repo.getAll();
    expect(items, isNotEmpty);
    expect(items.any((t) => t.isIncome), isTrue);
    expect(items.any((t) => !t.isIncome), isTrue);
  });
}
