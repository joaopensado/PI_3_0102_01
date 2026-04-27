import 'package:flutter/material.dart';
import 'tela_h15.dart';

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/fundo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ARQUIVO\nCAPIVARA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontFamily: 'PixelifySans',
                    height: 1.2,
                    shadows: [
                      Shadow(color: Colors.black, blurRadius: 8, offset: Offset(4, 4)),
                      Shadow(color: Colors.cyan, blurRadius: 15, offset: Offset(0, 0)),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                _buildBotaoPixel("NOVO JOGO", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaH15()),
                  );
                }, false),
                SizedBox(height: 20),
                _buildBotaoPixel("CONTINUAR", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Funcionalidade em desenvolvimento!'), backgroundColor: Colors.orange),
                  );
                }, false),
                SizedBox(height: 15),
                _buildBotaoPixel("CRÉDITOS", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Creditos()),
                  );
                }, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoPixel(String texto, VoidCallback onTap, bool pequeno) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: pequeno ? 10 : 18,
          horizontal: pequeno ? 25 : 55,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: pequeno ? 14 : 18,
            color: Colors.white,
            fontFamily: 'PixelifySans',
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class Creditos extends StatelessWidget {
  const Creditos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('CRÉDITOS', style: TextStyle(fontFamily: 'PixelifySans', fontSize: 18)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Spacer(),
            Text(
              'ARQUIVO CAPIVARA',
              style: TextStyle(fontFamily: 'PixelifySans', fontSize: 28, color: Colors.cyanAccent),
            ),
            SizedBox(height: 40),
            Text(
              'DESENVOLVIDO POR:',
              style: TextStyle(fontFamily: 'PixelifySans', fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 15),
            Text(
              'Ana Clara Coelho Chaves\nBrenda Maia Bergamasco\nCaio Cantarin\nJoão Pedro Rocha\nJoão Victor Pensado',
              style: TextStyle(fontFamily: 'PixelifySans', fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              'PUC-Campinas - 2026',
              style: TextStyle(fontFamily: 'PixelifySans', fontSize: 12, color: Colors.white54),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('VOLTAR', style: TextStyle(fontFamily: 'PixelifySans', color: Colors.white)),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}