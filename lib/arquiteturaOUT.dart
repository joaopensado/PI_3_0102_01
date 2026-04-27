import 'package:flutter/material.dart';
import 'arquiteturaIN.dart';

class TelaArquiteturaOUT extends StatefulWidget {
  @override
  _TelaArquiteturaOUTState createState() => _TelaArquiteturaOUTState();
}

class _TelaArquiteturaOUTState extends State<TelaArquiteturaOUT> {

  // 🗣️ LISTA DE FALAS
  List<String> dialogos = [
    "O jogador chega no prédio de arquitetura...",
    "'Ao caminhar pelos corredores, ouve ao fundo um resmungo vindo de uma das salas.'",
    "'Quando encontra a sala de onde vem os barulho, ele decide entrar.'",
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