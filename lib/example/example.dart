import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'example_transaction_create_screen.dart';
import 'transaction_url_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => TransactionUrlProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarlan Sample Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExampleTransactionCreateScreen(),
    );
  }
}
