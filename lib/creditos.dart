import 'package:flutter/material.dart';

class TextoScreen extends StatelessWidget {
  const TextoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('História'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Era uma vez uma capivara muito sábia...\n\n',
                  style: TextStyle(
                    fontSize: 24, // maior
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'Ela vivia na floresta e ajudava todos os animais.\n\n',
                  style: TextStyle(
                    fontSize: 18, // médio
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Um dia, algo inesperado aconteceu...',
                  style: TextStyle(
                    fontSize: 16, // menor
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}