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
    await _player.setReleaseMode(ReleaseMode.loop); // loop infinito
    await _player.play(AssetSource('audio/sompraca.mp3'));
  }

  @override
  void dispose() {
    _player.dispose(); // para o áudio ao sair da tela
    super.dispose();
  }

  // 🔥 TEXTO
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
          ElevatedButton(
            onPressed: () {
              print("Iniciar minigame direto");
            },
            child: const Text('Vamos nessa!'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                etapa = 4;
              });
            },
            child: const Text('Como é este desafio?'),
          ),
        ],
      );
    }

    if (etapa == 5) {
      return ElevatedButton(
        onPressed: () {
          print("Iniciar minigame depois da explicação");
        },
        child: const Text('Vamos nessa'),
      );
    }

    if (etapa == 7) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print("Ir procurar o koala");
            },
            child: const Text('Onde encontro o koala?'),
          ),
          ElevatedButton(
            onPressed: () {
              print("Ir direto ao koala");
            },
            child: const Text('Vou em busca do Koala!'),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget buildBotaoContinuar() {
    if (etapa == 3 || etapa == 5 || etapa == 7) {
      return const SizedBox();
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: avancar,
        child: const Text('Continuar'),
      ),
    );
  }

  Widget buildDialogo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textoAtual,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          buildOpcoes(),
          buildBotaoContinuar(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/fundo/pracaalimentacao.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            bottom: altura * 0.14,
            left: largura * 0.56,
            child: Image.asset(
              'assets/personagens/ratatoni.png',
              height: altura * 0.50,
            ),
          ),

          Positioned(
            left: largura * 0.35,
            bottom: altura * 0.08,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: largura * 0.40,
              ),
              child: buildDialogo(),
            ),
          ),
        ],
      ),
    );
  }
}