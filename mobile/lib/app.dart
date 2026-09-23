import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/transaction_repository.dart';

class MoneyHubApp extends StatelessWidget {
  const MoneyHubApp({super.key, required this.repository});

  final TransactionRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(repository: repository),
    );
  }
}
