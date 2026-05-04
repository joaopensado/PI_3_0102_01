import 'package:flutter/material.dart';
import 'biblioteca_principal.dart';
import 'biblioteca_image_screen.dart';

class BibliotecaHallScreen extends StatelessWidget {
  const BibliotecaHallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BibliotecaSceneScaffold(
      imageAsset: 'assets/biblioteca/biblioteca_hall.png',
      titulo: 'BIBLIOTECA - HALL',
      descricao:
          'Você está no hall da biblioteca.\nClique no marcador para seguir para a área principal.',
      dicaRodape: '[ CLIQUE NO MARCADOR PARA CONTINUAR ]',
      overlayBuilder: (context, size) {
        return BibliotecaIndicadorEntrada(
          leftFactor: 0.69,
          topFactor: 0.47,
          sizeFactor: 0.065,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BibliotecaPrincipalScreen()),
            );
          },
        );
      },
    );
  }
}
