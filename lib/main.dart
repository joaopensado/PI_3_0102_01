import 'package:flutter/material.dart';
import 'tela_inicial.dart';
import 'tela_h15.dart';
import 'arquiteturaOUT.dart';
import 'tela_mapa_exploracao.dart';
import 'entradaManacas.dart';
import 'pracaalimentacao.dart';

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
      routes: {
        '/h15': (context) => TelaH15(),
        '/mapa': (context) => TelaMapaExploracao(),
        '/h12': (context) => TelaArquiteturaOUT(),
        '/biblioteca': (context) => TelaH15(),
        '/refeitorio': (context) => Telapracaalimentacao(),
        '/manacas': (context) => EntradaScreen(),
      },
    );
  }
}