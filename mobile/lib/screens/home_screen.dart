import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/transaction.dart';
import '../services/finance_summary.dart';
import '../services/money_formatter.dart';
import '../services/transaction_repository.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final TransactionRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openAddTransaction() async {
    final created = await Navigator.of(context).push<Transaction>(
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
    if (!mounted) return;
    if (created != null) {
      setState(() => widget.repository.add(created));
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.repository.getAll();
    final summary = FinanceSummary(transactions);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('MoneyHub')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_transaction'),
        onPressed: _openAddTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Novo lançamento'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo', style: theme.textTheme.titleMedium),
                  Text(
                    formatBRL(summary.balance),
                    key: const Key('balance'),
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Receitas: ${formatBRL(summary.totalIncome)}',
                    key: const Key('total_income'),
                  ),
                  Text(
                    'Despesas: ${formatBRL(summary.totalExpense)}',
                    key: const Key('total_expense'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('Nenhum lançamento cadastrado.'))
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      return ListTile(
                        leading: Icon(
                          t.isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.isIncome ? Colors.green : Colors.red,
                        ),
                        title: Text(t.description),
                        subtitle: Text('${t.category} • ${formatDate(t.date)}'),
                        trailing: Text(formatBRL(t.signedAmountInCents)),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'versão ${AppConfig.version}',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
