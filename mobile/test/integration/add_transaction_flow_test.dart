// Teste de integração entre componentes (telas + repositório + cálculo de
// saldo), executado no pipeline de CI com `flutter test`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneyhub_mobile/app.dart';
import 'package:moneyhub_mobile/services/transaction_repository.dart';

Future<void> _addTransaction(
  WidgetTester tester, {
  required String description,
  required String amount,
  required String category,
  bool income = false,
}) async {
  await tester.tap(find.byKey(const Key('add_transaction')));
  await tester.pumpAndSettle();

  if (income) {
    await tester.tap(find.text('Receita'));
    await tester.pump();
  }

  await tester.enterText(
    find.byKey(const Key('field_description')),
    description,
  );
  await tester.enterText(find.byKey(const Key('field_amount')), amount);
  await tester.enterText(find.byKey(const Key('field_category')), category);

  await tester.tap(find.byKey(const Key('save_button')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cadastrar receita e despesa atualiza o saldo', (tester) async {
    final repository = InMemoryTransactionRepository();
    await tester.pumpWidget(MoneyHubApp(repository: repository));

    await _addTransaction(
      tester,
      description: 'Freela',
      amount: '2.000,00',
      category: 'Trabalho',
      income: true,
    );

    expect(find.text('Freela'), findsOneWidget);
    expect(find.byKey(const Key('balance')), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('balance'))).data,
      'R\$ 2.000,00',
    );

    await _addTransaction(
      tester,
      description: 'Internet',
      amount: '99,90',
      category: 'Casa',
    );

    expect(find.text('Internet'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('balance'))).data,
      'R\$ 1.900,10',
    );
    expect(repository.getAll(), hasLength(2));
  });
}
