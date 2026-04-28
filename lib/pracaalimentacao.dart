import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Telapracaalimentacao extends StatefulWidget {
  const Telapracaalimentacao({super.key});

  @override
  State<Telapracaalimentacao> createState() => _TelapracaalimentacaoState();
}

class _TelapracaalimentacaoState extends State<Telapracaalimentacao> {

  int etapa = 0;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    tocarAudio();
  }

  Future<void> tocarAudio() async {
    await _player.setVolume(1.0);
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/sompraca.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String get textoAtual {
    switch (etapa) {
      case 0:
        return 'Don Ratatoni:\n Olá criatura feia, em que posso te ajudar?';
      case 1:
        return 'Jogador:\n Estou a procura de um animal desaparecido no Campus, ele está com você?';
      case 2:
        return 'Don Ratatoni:\n Ah sim, tenho uma informação útil... mas só direi se completar um desafio!';
      case 3:
        return 'Escolha:';
      case 4:
        return 'Don Ratatoni:\n Você terá que fazer três hambúrgueres corretamente seguindo os pedidos!';
      case 5:
        return 'Escolha:';
      case 6:
        return 'Don Ratatoni:\n Muito bem! O animal desaparecido foi visto com um hambúrguer...';
      case 7:
        return 'Escolha:';
      default:
        return '';
    }
  }

  void avancar() {
    setState(() {
      etapa++;
    });
  }

  Widget buildOpcoes() {
    if (etapa == 3) {
      return Column(
        children: [
          _botaoPixel('Vamos nessa!', () {
            print("Iniciar minigame direto");
          }),
          SizedBox(height: 10),
          _botaoPixel('Como é este desafio?', () {
            setState(() {
              etapa = 4;
            });
          }),
        ],
      );
    }

    if (etapa == 5) {
      return _botaoPixel('Vamos nessa', () {
        print("Iniciar minigame depois da explicação");
      });
    }

    if (etapa == 7) {
      return Column(
        children: [
          _botaoPixel('Onde encontro o koala?', () {
            print("Ir procurar o koala");
          }),
          SizedBox(height: 10),
          _botaoPixel('Vou em busca do Koala!', () {
            print("Ir direto ao koala");
          }),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _botaoPixel(String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF1a1f3a),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PixelifySans',
            color: Colors.cyanAccent,
          ),
        ),
      ),
    );
  }

  Widget buildBotaoContinuar() {
    if (etapa == 3 || etapa == 5 || etapa == 7) {
      return const SizedBox();
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: avancar,
        child: Text(
          'Continuar',
          style: TextStyle(color: Colors.cyanAccent),
        ),
      ),
    );
  }

  Widget buildDialogo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF0a0e27).withOpacity(0.95),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 15, offset: Offset(6, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // NOME
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 7, 7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'RATATONI',
              style: TextStyle(
                fontFamily: 'PixelifySans',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 12),

          Text(
            textoAtual,
            style: TextStyle(
              fontFamily: 'PixelifySans',
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          SizedBox(height: 12),

          buildOpcoes(),
          buildBotaoContinuar(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          // FUNDO
          Positioned.fill(
            child: Image.asset(
              'assets/fundo/pracaalimentacao.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // OVERLAY ESCURO
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // PERSONAGEM
          Positioned(
            left: 0,
            bottom: 90,
            child: Image.asset(
              'assets/personagens/ratatoni.png',
              height: 400,
            ),
          ),

          // DIÁLOGO
          Positioned(
            right: 20,
            left: 300,
            bottom: 80,
            child: buildDialogo(),
          ),
        ],
      ),
    );
  }
}