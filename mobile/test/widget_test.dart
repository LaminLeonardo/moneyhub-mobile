import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneyhub_mobile/app.dart';
import 'package:moneyhub_mobile/services/transaction_repository.dart';

void main() {
  testWidgets('tela inicial sem lançamentos mostra saldo zerado', (
    tester,
  ) async {
    await tester.pumpWidget(
      MoneyHubApp(repository: InMemoryTransactionRepository()),
    );

    expect(find.text('MoneyHub'), findsOneWidget);
    expect(find.text('R\$ 0,00'), findsOneWidget);
    expect(find.text('Nenhum lançamento cadastrado.'), findsOneWidget);
  });

  testWidgets('tela inicial com dados de exemplo lista lançamentos', (
    tester,
  ) async {
    await tester.pumpWidget(
      MoneyHubApp(repository: InMemoryTransactionRepository.withSampleData()),
    );

    expect(find.text('Salário'), findsOneWidget);
    expect(find.text('Aluguel'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('formulário valida campos obrigatórios', (tester) async {
    await tester.pumpWidget(
      MoneyHubApp(repository: InMemoryTransactionRepository()),
    );

    await tester.tap(find.byKey(const Key('add_transaction')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pump();

    expect(find.text('Informe a descrição'), findsOneWidget);
    expect(find.text('Informe um valor maior que zero'), findsOneWidget);
  });
}
