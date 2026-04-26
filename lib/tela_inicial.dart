import 'package:flutter/material.dart';
import 'creditos.dart';

// ================= TELA INICIAL =================
class TelaInicial extends StatelessWidget {
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

          // LEVE ESCURECIMENTO (pra destacar texto)
          Container(
            color: Colors.black.withOpacity(0.1),
          ),

          // CONTEÚDO CENTRAL
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                //TÍTULO
                Text(
                  "ARQUIVO\nCAPIVARA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                    fontFamily: 'PixelifySans',
                    height: 1.3,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: Offset(3, 3),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 50),

                // BOTÕES
                PixelButton(
                  text: "NOVO JOGO",
                  onTap: () {
                    print("Novo jogo");
                  },
                ),

                SizedBox(height: 20),

                PixelButton(
                  text: "CONTINUAR",
                  onTap: () {
                    print("Continuar");
                  },
                ),

                SizedBox(height: 15),

                PixelButton(
                    text: "CRÉDITOS",
                    small: true,
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Creditos(),
                            ),
                        );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= BOTÃO =================
class PixelButton extends StatefulWidget {
  final String text;
  final bool small;
  final VoidCallback onTap;

  PixelButton({
    required this.text,
    required this.onTap,
    this.small = false,
  });

  @override
  _PixelButtonState createState() => _PixelButtonState();
}

// Estetica do botao
class _PixelButtonState extends State<PixelButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => isPressed = true);
      },
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => isPressed = false);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          vertical: widget.small ? 8 : 16,
          horizontal: widget.small ? 20 : 50,
        ),
        decoration: BoxDecoration(
          color: isPressed ? Colors.blue[700] : Colors.blue[900],
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                  )
                ],
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.small ? 12 : 16,
            color: Colors.white,
            fontFamily: 'PixelifySans',
          ),
        ),
      ),
    );
  }
}