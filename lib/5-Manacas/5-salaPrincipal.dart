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
                image: AssetImage('assets/sala_principal_cap.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Animal (centralizado ou onde preferir)
          // Center(
          //   child: Image.asset(
          //     'assets/animal.jpeg',
          //     width: 150,
          //     height: 150,
          //   ),
          //),
          // Botão de reiniciar no canto inferior direito
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: const Text('Reiniciar Fase'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}