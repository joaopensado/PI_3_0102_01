import 'package:flutter/material.dart';
import '5-corredor.dart';

class EntradaScreen extends StatelessWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo (ocupa toda a tela)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/entrada_manacas.jpeg'),
                fit: BoxFit.cover, // cobre toda a tela
              ),
            ),
          ),
          // Botão no canto inferior direito
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CorredorScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Entrar no Manacás'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}