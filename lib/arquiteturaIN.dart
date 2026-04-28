import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'arquiteturaOUT.dart';

// 🧠 MODELO DE DIÁLOGO
class Dialogo {
  final String texto;
  final String personagem;
  final String imagem;

  Dialogo({
    required this.texto,
    required this.personagem,
    required this.imagem,
  });
}

class TelaArquiteturaIN extends StatefulWidget {
  @override
  _TelaArquiteturaINState createState() => _TelaArquiteturaINState();
}

class _TelaArquiteturaINState extends State<TelaArquiteturaIN> {

  // 🎵 PLAYER
  final AudioPlayer _player = AudioPlayer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    tocarSom();
  }

  void tocarSom() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/background_music_arq.mp3'));
  }

  void toggleSom() async {
    setState(() {
      isMuted = !isMuted;
    });

    await _player.setVolume(isMuted ? 0 : 1);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // ---------------- DIÁLOGO ----------------

  List<Dialogo> dialogos = [

    Dialogo(
      texto: "Ao entrar na sala o jogador vê um coala sobre uma planta arquitetônica...",
      personagem: "narrador",
      imagem: "",
    ),

    Dialogo(
      texto: "Ah! Ei, você! Que bom que apareceu... preciso de ajuda...",
      personagem: "Koda",
      imagem: "",
    ),

    Dialogo(
      texto: "Claro! O que está acontecendo?",
      personagem: "jogador",
      imagem: "assets/personagens/player-masc.png",
    ),

    Dialogo(
      texto: "Estou com problemas nesse projeto arquitetônico...",
      personagem: "Koda",
      imagem: "",
    ),
  ];

  int indiceAtual = 0;

  void proximoDialogo() {
    if (indiceAtual < dialogos.length - 1) {
      setState(() {
        indiceAtual++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    bool acabouDialogo = indiceAtual == dialogos.length - 1;
    Dialogo atual = dialogos[indiceAtual];

    return Scaffold(
      body: GestureDetector(
        onTap: acabouDialogo ? null : proximoDialogo,
        child: Stack(
          children: [

            // 🎨 FUNDO
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fundo/sala-arq-pxl.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 👤 PERSONAGEM
            if (atual.personagem != "narrador")
              Align(
                alignment: atual.personagem == "Koda"
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 120,
                    left: atual.personagem == "jogador" ? 20 : 0,
                    right: atual.personagem == "Koda" ? 20 : 0,
                  ),
                  child: Image.asset(
                    atual.imagem,
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            // 🔈 BOTÃO DE SOM
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: toggleSom,
              ),
            ),

            // 💬 CAIXA DE DIÁLOGO
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      atual.texto,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 10),

                    if (acabouDialogo)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaArquiteturaOUT(),
                            ),
                          );
                        },
                        child: Text("Começar desafio"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}