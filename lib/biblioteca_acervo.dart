import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tela_inicial.dart';

// ═══════════════════════════════════════════════
//  TELA 4 — Corredor do Acervo (estantes)
// ═══════════════════════════════════════════════
class BibliotecaAcervoScreen extends StatefulWidget {
  const BibliotecaAcervoScreen({super.key});

  @override
  State<BibliotecaAcervoScreen> createState() =>
      _BibliotecaAcervoScreenState();
}

class _BibliotecaAcervoScreenState extends State<BibliotecaAcervoScreen> {
  // ── Áudio ──
  final AudioPlayer _player = AudioPlayer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _tocarSom();
  }

  Future<void> _tocarSom() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/background_music_arq.mp3'));
  }

  Future<void> _toggleSom() async {
    setState(() => isMuted = !isMuted);
    await _player.setVolume(isMuted ? 0 : 1);
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
          // ── Cena pixel art ──
          CustomPaint(
            painter: _AcervoPainter(),
            child: const SizedBox.expand(),
          ),

          // ── Botão de som ──
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleSom,
            ),
          ),

          // ── Caixa de diálogo com botão de voltar ──
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ACERVO',
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      fontSize: 20,
                      color: Colors.cyanAccent,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Você explorou toda a biblioteca!\nO conhecimento está ao alcance das suas mãos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão voltar ao menu — mesmo estilo do jogo
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => TelaInicial()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(5, 5))
                        ],
                      ),
                      child: const Text(
                        'VOLTAR AO MENU',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'PixelifySans',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Paleta de cores de livros ──
const List<Color> _bookColors = [
  Color(0xFFE53935), Color(0xFF1565C0), Color(0xFF2E7D32),
  Color(0xFFF57F17), Color(0xFF6A1B9A), Color(0xFF00838F),
  Color(0xFF4E342E), Color(0xFF37474F), Color(0xFF558B2F),
  Color(0xFFAD1457), Color(0xFFF4511E), Color(0xFF00695C),
  Color(0xFF283593), Color(0xFF827717), Color(0xFF880E4F),
  Color(0xFFC62828), Color(0xFF0D47A1), Color(0xFF1B5E20),
];

Color _bookAt(int idx) => _bookColors[idx % _bookColors.length];

// ═══════════════════════════════════════════════
//  PAINTER — Corredor de acervo (perspectiva)
// ═══════════════════════════════════════════════
class _AcervoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..style = PaintingStyle.fill;

    // ── Borda preta (estilo da imagem original) ──
    p.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), p);

    const double bdr = 12.0;
    final Rect inner = Rect.fromLTWH(bdr, bdr, w - bdr * 2, h - bdr * 2);
    canvas.save();
    canvas.clipRect(inner);

    // ── Teto ──
    p.color = const Color(0xFF3E3E3E);
    canvas.drawRect(Rect.fromLTWH(bdr, bdr, w - bdr * 2, h * 0.20), p);

    // Dutos no teto
    p.color = const Color(0xFF555555);
    canvas.drawRect(Rect.fromLTWH(bdr, bdr + h * 0.02, w - bdr * 2, h * 0.025), p);
    p.color = const Color(0xFF4A4A4A);
    canvas.drawRect(Rect.fromLTWH(bdr, bdr + h * 0.07, w - bdr * 2, h * 0.018), p);

    final double cx = w / 2;
    final double vanishY = h * 0.35;

    // Luminárias perspectivadas
    p.color = const Color(0xFFFFF8C0);
    final List<double> lightSizes = [
      w * 0.30, w * 0.22, w * 0.16, w * 0.11, w * 0.07
    ];
    final List<double> lightYs = [
      h * 0.12, h * 0.155, h * 0.175, h * 0.190, h * 0.200
    ];
    for (int i = 0; i < lightSizes.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(cx - lightSizes[i] / 2, bdr + lightYs[i], lightSizes[i], h * 0.018),
        p,
      );
    }
    p.color = const Color(0xFFFFF8C0).withOpacity(0.08);
    canvas.drawRect(Rect.fromLTWH(bdr, bdr, w - bdr * 2, h * 0.22), p);

    // ── Chão ──
    p.color = const Color(0xFF3A3A40);
    canvas.drawRect(Rect.fromLTWH(bdr, h * 0.70, w - bdr * 2, h * 0.30), p);

    // Grade do chão
    p.color = const Color(0xFF303038);
    for (int r = 0; r < 8; r++) {
      canvas.drawRect(
          Rect.fromLTWH(bdr, h * 0.70 + r * h * 0.042, w - bdr * 2, 1), p);
    }

    // Reflexo das luminárias no chão
    p.color = Colors.white.withOpacity(0.06);
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.12, h * 0.70, w * 0.24, h * 0.08), p);

    // Linhas brancas no chão
    p.color = Colors.white.withOpacity(0.80);
    canvas.drawRect(Rect.fromLTWH(cx - 2, h * 0.70, 4, h * 0.30), p);
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.14, h * 0.70, 4, h * 0.30), p);
    canvas.drawRect(Rect.fromLTWH(cx + w * 0.14, h * 0.70, 4, h * 0.30), p);

    // Faixa tátil vermelha (rodapé)
    p.color = const Color(0xFFCC1100);
    canvas.drawRect(Rect.fromLTWH(bdr, h * 0.94, w - bdr * 2, h * 0.06), p);
    p.color = const Color(0xFFBB0F00);
    for (int i = 0; i < 18; i++) {
      canvas.drawCircle(
        Offset(bdr + 20 + i * ((w - bdr * 2 - 20) / 18), h * 0.97),
        4,
        p,
      );
    }

    // ── Estantes com perspectiva ──
    _drawShelfSide(canvas, p, w, h,
        side: 'left', cx: cx, vanishY: vanishY, bdr: bdr);
    _drawShelfSide(canvas, p, w, h,
        side: 'right', cx: cx, vanishY: vanishY, bdr: bdr);

    // ── Fundo do corredor (passagem) ──
    p.color = const Color(0xFF1A1A1A);
    canvas.drawRect(
        Rect.fromLTWH(cx - w * 0.05, vanishY, w * 0.10, h * 0.40), p);
    p.color = const Color(0xFF252525);
    canvas.drawRect(
        Rect.fromLTWH(cx - w * 0.04, vanishY + h * 0.01, w * 0.08, h * 0.38), p);

    canvas.restore();
  }

  void _drawShelfSide(
    Canvas canvas,
    Paint p,
    double w,
    double h, {
    required String side,
    required double cx,
    required double vanishY,
    required double bdr,
  }) {
    final bool isLeft = side == 'left';
    const int numBays = 3;

    for (int bay = 0; bay < numBays; bay++) {
      final double t0 = bay / numBays;
      final double t1 = (bay + 1) / numBays;

      final double xFront = isLeft
          ? bdr + (cx - bdr) * (1 - t0) * 0.42
          : w - bdr - (w - bdr - cx) * (1 - t0) * 0.42;
      final double xBack = isLeft
          ? bdr + (cx - bdr) * (1 - t1) * 0.42
          : w - bdr - (w - bdr - cx) * (1 - t1) * 0.42;

      final double yFront = h * 0.20 + t0 * (h * 0.70 - h * 0.20);
      final double yBack = h * 0.20 + t1 * (h * 0.70 - h * 0.20);

      // Estrutura da estante
      p.color = const Color(0xFFC8A868);
      final Path shelf = Path();
      if (isLeft) {
        shelf
          ..moveTo(bdr, yFront)
          ..lineTo(xFront, yFront)
          ..lineTo(xBack, yBack)
          ..lineTo(bdr, yBack)
          ..close();
      } else {
        shelf
          ..moveTo(w - bdr, yFront)
          ..lineTo(xFront, yFront)
          ..lineTo(xBack, yBack)
          ..lineTo(w - bdr, yBack)
          ..close();
      }
      canvas.drawPath(shelf, p);

      // Livros nas prateleiras
      final double shelfHeight = yBack - yFront;
      const int numRows = 5;
      final double rowH = shelfHeight / numRows;

      for (int row = 0; row < numRows; row++) {
        final double rowY = yFront + row * rowH;

        // Linha da prateleira
        p.color = const Color(0xFF8B6030);
        canvas.drawRect(
          Rect.fromLTWH(
            isLeft ? bdr : xFront,
            rowY,
            isLeft ? xFront - bdr : w - bdr - xFront,
            2.5,
          ),
          p,
        );

        final int numBooks = (8 - bay * 2).clamp(3, 8);
        final double totalW = isLeft ? (xFront - bdr - 4) : (w - bdr - xFront - 4);
        final double bookW = totalW / numBooks;
        final double bookH = rowH - 4;

        for (int b = 0; b < numBooks; b++) {
          p.color = _bookAt(bay * 20 + row * 8 + b);
          final double bx =
              isLeft ? bdr + 2 + b * bookW : xFront + 2 + b * bookW;
          final double by = rowY + 2.5;
          canvas.drawRect(Rect.fromLTWH(bx, by, bookW - 1, bookH), p);
          p.color = p.color.withOpacity(0.5);
          canvas.drawRect(Rect.fromLTWH(bx, by, 2, bookH), p);
        }

        // Etiqueta de classificação
        if (row == 0) {
          p.color = Colors.white.withOpacity(0.85);
          canvas.drawRect(
            Rect.fromLTWH(
                isLeft ? bdr + 2 : xFront + 2, yFront - 8, 40, 8),
            p,
          );
        }
      }

      // Pilar vertical
      p.color = const Color(0xFF9A7040);
      canvas.drawRect(
        Rect.fromLTWH(
          isLeft ? xFront - 4 : xFront,
          yFront,
          4,
          yBack - yFront,
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}