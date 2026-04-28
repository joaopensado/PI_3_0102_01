import 'package:flutter/material.dart';
import 'corredor.dart'; // verifique se o nome do arquivo está correto

class EntradaScreen extends StatelessWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/entrada_manacas.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Imagem de pegadas clicável
          Positioned(
            bottom: 250,
            right: 930,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CorredorScreen()),
                );
              },
              child: Image.asset(
                'assets/fundo/pegadas.png',
                width: 300,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}