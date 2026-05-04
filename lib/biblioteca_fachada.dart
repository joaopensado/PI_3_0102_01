import 'package:flutter/material.dart';
import 'biblioteca_hall.dart';
import 'biblioteca_image_screen.dart';

class BibliotecaFachadaScreen extends StatelessWidget {
  const BibliotecaFachadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BibliotecaSceneScaffold(
      imageAsset: 'assets/biblioteca/biblioteca_fachada.png',
      titulo: 'BIBLIOTECA - FACHADA',
      descricao:
          'Você chegou à entrada da biblioteca.\nClique no marcador da rampa para entrar no prédio.',
      dicaRodape: '[ CLIQUE NO MARCADOR PARA ENTRAR ]',
      overlayBuilder: (context, size) {
        return BibliotecaIndicadorEntrada(
          leftFactor: 0.60,
          topFactor: 0.46,
          sizeFactor: 0.07,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BibliotecaHallScreen()),
            );
          },
        );
      },
    );
  }
}
