import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '4-arquiteturaIN.dart';

// 🧠 MODELO
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

class TelaArquiteturaOUT extends StatefulWidget {
  @override
  _TelaArquiteturaOUTState createState() => _TelaArquiteturaOUTState();
}

class _TelaArquiteturaOUTState extends State<TelaArquiteturaOUT> {

  // 🎵 AUDIO
  final AudioPlayer _player = AudioPlayer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    tocarSom();
    iniciarDigitacao();
  }

  void tocarSom() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/background_music_arq.mp3'));
  }

  void toggleSom() async {
    setState(() {
      isMuted = !isMuted;
    });

    if (isMuted) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    timer?.cancel();
    super.dispose();
  }

  // ---------------- DIÁLOGO ----------------

  List<Dialogo> dialogos = [

    Dialogo(
      texto: "O jogador chega no prédio de arquitetura...",
      personagem: "narrador",
      imagem: "",
    ),

    Dialogo(
      texto: "Ao caminhar pelos corredores, ouve ao fundo um resmungo vindo de uma das salas.",
      personagem: "narrador",
      imagem: "",
    ),

    Dialogo(
      texto: "Quando encontra a sala de onde vem os barulho, ele decide entrar.",
      personagem: "narrador",
      imagem: "",
    ),
  ];

  int indiceAtual = 0;

  // 🔥 TYPEWRITER
  String textoAtual = "";
  int charIndex = 0;
  Timer? timer;

  void iniciarDigitacao() {
    timer?.cancel();
    textoAtual = "";
    charIndex = 0;

    String fullText = dialogos[indiceAtual].texto;

    timer = Timer.periodic(Duration(milliseconds: 30), (t) {
      if (charIndex < fullText.length) {
        setState(() {
          textoAtual += fullText[charIndex];
          charIndex++;
        });
      } else {
        t.cancel();
      }
    });
  }

  void proximoDialogo() {
    String fullText = dialogos[indiceAtual].texto;

    if (textoAtual.length < fullText.length) {
      setState(() {
        textoAtual = fullText;
      });
      return;
    }

    if (indiceAtual < dialogos.length - 1) {
      setState(() {
        indiceAtual++;
      });
      iniciarDigitacao();
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
                  image: AssetImage('assets/fundo/arq-outside-pxl.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔈 BOTÃO
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

            // 💬 CAIXA PADRÃO VN
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🏷️ NARRADOR
                    if (atual.personagem != "narrador")
                      Text(
                        atual.personagem,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    SizedBox(height: 6),

                    // 💬 TEXTO COM EFEITO
                    Text(
                      textoAtual,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        if (acabouDialogo)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaArquiteturaIN(),
                                ),
                              );
                            },
                            child: Text("Entrar"),
                          ),

                        if (!acabouDialogo)
                          Text(
                            "▼",
                            style: TextStyle(color: Colors.white54),
                          ),
                      ],
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