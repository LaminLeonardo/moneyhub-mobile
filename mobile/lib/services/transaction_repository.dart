import '../models/transaction.dart';

/// Contrato de acesso aos lançamentos. Na próxima fase será implementado
/// consumindo a API .NET do MoneyHub; por ora há a versão em memória.
abstract interface class TransactionRepository {
  List<Transaction> getAll();
  void add(Transaction transaction);
  void remove(String id);
}

class InMemoryTransactionRepository implements TransactionRepository {
  InMemoryTransactionRepository([List<Transaction>? initial])
      : _items = [...?initial];

  factory InMemoryTransactionRepository.withSampleData() {
    final now = DateTime.now();
    return InMemoryTransactionRepository([
      Transaction(
        id: 'seed-1',
        description: 'Salário',
        amountInCents: 500000,
        type: TransactionType.income,
        category: 'Trabalho',
        date: DateTime(now.year, now.month, 5),
      ),
      Transaction(
        id: 'seed-2',
        description: 'Aluguel',
        amountInCents: 150000,
        type: TransactionType.expense,
        category: 'Moradia',
        date: DateTime(now.year, now.month, 10),
      ),
      Transaction(
        id: 'seed-3',
        description: 'Mercado',
        amountInCents: 45990,
        type: TransactionType.expense,
        category: 'Alimentação',
        date: DateTime(now.year, now.month, 12),
      ),
    ]);
  }

  final List<Transaction> _items;

  /// Retorna os lançamentos do mais recente para o mais antigo.
  @override
  List<Transaction> getAll() {
    final sorted = [..._items]..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

  @override
  void add(Transaction transaction) {
    if (_items.any((t) => t.id == transaction.id)) {
      throw ArgumentError('Já existe um lançamento com id ${transaction.id}');
    }
    _items.add(transaction);
  }

  @override
  void remove(String id) {
    _items.removeWhere((t) => t.id == id);
  }
}
