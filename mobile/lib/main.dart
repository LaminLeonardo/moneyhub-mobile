import 'package:flutter/material.dart';

import 'app.dart';
import 'services/transaction_repository.dart';

void main() {
  runApp(
    MoneyHubApp(repository: InMemoryTransactionRepository.withSampleData()),
  );
}
