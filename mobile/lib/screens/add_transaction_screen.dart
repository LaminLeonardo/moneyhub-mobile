import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/money_formatter.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  TransactionType _type = TransactionType.expense;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final transaction = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      description: _descriptionController.text.trim(),
      amountInCents: parseAmountToCents(_amountController.text)!,
      type: _type,
      category: _categoryController.text.trim().isEmpty
          ? 'Geral'
          : _categoryController.text.trim(),
      date: DateTime.now(),
    );
    Navigator.of(context).pop(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lançamento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Despesa'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Receita'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) {
                setState(() => _type = selection.first);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('field_description'),
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe a descrição'
                  : null,
            ),
            TextFormField(
              key: const Key('field_amount'),
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => parseAmountToCents(value) == null
                  ? 'Informe um valor maior que zero'
                  : null,
            ),
            TextFormField(
              key: const Key('field_category'),
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('save_button'),
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
