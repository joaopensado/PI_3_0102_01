import 'package:flutter/material.dart';
import 'tela_inicial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicial(), // Agora chamando a tela do outro arquivo
    );
  }
}


