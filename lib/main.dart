import 'package:flutter/material.dart';
import 'tela_inicial.dart';
import 'arquiteturaOUT.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arquivo Capivara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue[900],
        fontFamily: 'monospace',
      ),
      home: TelaInicial(),
    );
  }
}