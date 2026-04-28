import 'package:flutter/material.dart';
import 'tela_h15.dart';
import 'arquiteturaOUT.dart';
import 'creditos.dart';

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
                  _mostrarEscolhaLocal(context);
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

  void _mostrarEscolhaLocal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ESCOLHA O LOCAL",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    fontSize: 18,
                    color: Colors.cyanAccent,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20),

                _buildBotaoPixel("H15 TECNOLOGIA", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/mapa');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("BIBLIOTECA", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/biblioteca');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("PRAÇA", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/refeitorio');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("H12 ARQUITETURA", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/h12');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("MANACÁS (CAVE)", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/manacas');
                }, true),

                SizedBox(height: 15),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
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