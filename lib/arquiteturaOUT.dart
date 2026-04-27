import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'arquiteturaIN.dart';

class TelaArquiteturaOUT extends StatefulWidget {
  @override
  _TelaArquiteturaOUTState createState() => _TelaArquiteturaOUTState();
}

class _TelaArquiteturaOUTState extends State<TelaArquiteturaOUT> {

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

  if (isMuted) {
    await _player.pause();
  } else {
    await _player.resume();
  }
}

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

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

  void proximoDialogo() {
    if (indiceAtual < dialogos.length - 1) {
      setState(() {
        indiceAtual++;
      });
    } else {
      print("Fim do diálogo");
    }
  }

  @override
  Widget build(BuildContext context) {

    bool acabouDialogo = indiceAtual == dialogos.length - 1;

    return Scaffold(
      body: GestureDetector( // 👈 detecta toque na tela
        onTap: acabouDialogo ? null : proximoDialogo,
        child: Stack(
          children: [

            // 🎨 FUNDO DO JOGO
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fundo/arq-outside-pxl.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // TEXTO
                    Text(
                      dialogos[indiceAtual],
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
                              builder: (context) => TelaArquiteturaIN(),
                            ),
                          );
                        },
                        child: Text("Entrar"),
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