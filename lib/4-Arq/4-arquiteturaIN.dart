import 'package:flutter/material.dart';
import '4-arquiteturaOUT.dart';

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

  List<Dialogo> dialogos = [

    Dialogo(
      texto: "Ao entrar na sala o jogador vê um coala sobre uma planta arquitetônica...",
      personagem: "narrador",
      imagem: "",
    ),

    Dialogo(
      texto: "Ah! Ei, você! Que bom que apareceu... preciso de ajuda...",
      personagem: "Koda",
      imagem: "assets/personagens/koda.png",
    ),

    Dialogo(
      texto: "Claro! O que está acontecendo?",
      personagem: "jogador",
      imagem: "assets/personagens/player-masc.png",
    ),

    Dialogo(
      texto: "Estou com problemas nesse projeto arquitetônico...",
      personagem: "Koda",
      imagem: "assets/personagens/koda.png",
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

            // 👤 PERSONAGEM NO CENÁRIO
            if (atual.personagem != "narrador")
              Align(
                alignment: atual.personagem == "Koda"
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 20, // sobe acima da caixa
                    right: atual.personagem == "coala" ? 20 : 0,
                    left: atual.personagem == "jogador" ? 20 : 0,
                  ),
                  child: Image.asset(
                    atual.imagem,
                    height: 260, // 👈 aumentei pra ficar mais destaque
                    fit: BoxFit.contain,
                  ),
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

                    // TEXTO
                    Text(
                      atual.texto,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 10),

                    // BOTÃO FINAL
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