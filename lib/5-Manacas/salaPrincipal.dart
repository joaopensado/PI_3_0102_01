import 'package:flutter/material.dart';

class SalaPrincipalScreen extends StatelessWidget {
  const SalaPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo (sala principal)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/sala_principal_cap.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Imagem do personagem posicionada com Positioned
          Positioned(
            top: 300,
            left: 600,
            child: SizedBox(
              width: 900,
              height: 550,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset('assets/personagens/capivarilda_atacada.png'),
              ),
            ),
          ),
          // Botão posicionado no canto inferior direito
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Reiniciar Fase'),
            ),
          ),
        ],
      ),
    );
  }
}