import 'package:flutter/material.dart';
import 'presentation/screens/catalog_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnackDistro',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}
