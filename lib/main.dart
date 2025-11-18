import 'package:flutter/material.dart';
import 'package:archify/ui/page/main_page.dart';

void main() {
  runApp(const ArchifyApp());
}

class ArchifyApp extends StatelessWidget {
  const ArchifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Archify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainPage(),
    );
  }
}
  
