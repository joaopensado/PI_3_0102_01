import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tela_h15.dart';
import 'arquiteturaOUT.dart';
import 'creditos.dart';

class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  int etapa = 0;
  final AudioPlayer _player = AudioPlayer();
  bool _mutado = false; // NOVO: controle de mute

  @override
  void initState() {
    super.initState();
    tocarAudio();
  }

  Future<void> tocarAudio() async {
    await _player.setVolume(1.0);
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/somtelainicial.mp3'));
  }

  // NOVO: alterna entre mute e unmute
  Future<void> _alternarMute() async {
    setState(() {
      _mutado = !_mutado;
    });
    await _player.setVolume(_mutado ? 0.0 : 1.0);
  }

  // Para o áudio e navega para a rota
  Future<void> _navegarPara(BuildContext context, String rota) async {
    await _player.stop();
    Navigator.pushNamed(context, rota);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // FUNDO
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/fundo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ESCURECIMENTO
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // CONTEÚDO
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
                    SnackBar(
                      content: Text('Funcionalidade em desenvolvimento!'),
                      backgroundColor: Colors.orange
                    ),
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

          // NOVO: Botão mute/unmute no canto superior direito
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _alternarMute,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: Icon(
                  _mutado ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
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

                _buildBotaoPixel("TESTAR NOVO JOGO", () { 
                  Navigator.pop(context);
                  _navegarPara(context, '/mapa');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("H15 TECNOLOGIA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/h15');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("BIBLIOTECA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/biblioteca');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("PRAÇA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/refeitorio');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("H12 ARQUITETURA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/h12');
                }, true),

                SizedBox(height: 10),

                _buildBotaoPixel("MANACÁS (CAVE)", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/manacas');
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