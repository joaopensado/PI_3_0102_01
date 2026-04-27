import 'package:flutter/material.dart';

class Creditos extends StatelessWidget {
  const Creditos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Créditos'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'CRÉDITOS\n\n',
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Chat GPT para criar imagens;\n',
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Dramina IA para pixelar imagens',
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // centraliza o texto
            ),
          ),
        ),
      ),
    );
  }
}