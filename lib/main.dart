import 'package:flutter/material.dart';
import 'arquiteturaOUT.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaArquiteturaOUT(), // Agora chamando a tela do outro arquivo
    );
  }
}


