import 'package:flutter/material.dart';
import 'salaPrincipal.dart';

class CorredorScreen extends StatelessWidget {
  const CorredorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/corredor_manacas.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 800,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalaPrincipalScreen()),
                );
              },
              child: Image.asset(
                'assets/fundo/pegadas.png',
                width: 250,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}