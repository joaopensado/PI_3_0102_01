import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'biblioteca_acervo.dart';

// ═══════════════════════════════════════════════
//  TELA 3 — Biblioteca Principal (Área de Leitura)
// ═══════════════════════════════════════════════
class BibliotecaPrincipalScreen extends StatefulWidget {
  const BibliotecaPrincipalScreen({super.key});

  @override
  State<BibliotecaPrincipalScreen> createState() =>
      _BibliotecaPrincipalScreenState();
}

class _BibliotecaPrincipalScreenState
    extends State<BibliotecaPrincipalScreen> {
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
      body: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BibliotecaAcervoScreen()),
        ),
        child: Stack(
          children: [
            // ── Cena pixel art ──
            CustomPaint(
              painter: _PrincipalPainter(),
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

            // ── Caixa de diálogo ──
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
                      'ÁREA DE LEITURA',
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 20,
                        color: Colors.cyanAccent,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A Biblioteca Virtual Pearson está disponível.\nEscolha um lugar para estudar e explore o acervo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '[ TOQUE PARA EXPLORAR O ACERVO ]',
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 2,
                      ),
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

// ── Paleta de cores de livros ──
const List<Color> _bookColors = [
  Color(0xFFE53935), Color(0xFF1565C0), Color(0xFF2E7D32),
  Color(0xFFF57F17), Color(0xFF6A1B9A), Color(0xFF00838F),
  Color(0xFF4E342E), Color(0xFF37474F), Color(0xFF558B2F),
  Color(0xFFAD1457), Color(0xFFF4511E), Color(0xFF00695C),
  Color(0xFF283593), Color(0xFF827717), Color(0xFF880E4F),
];

Color _bookAt(int seed) => _bookColors[seed % _bookColors.length];

// ═══════════════════════════════════════════════
//  PAINTER — Biblioteca principal
// ═══════════════════════════════════════════════
class _PrincipalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..style = PaintingStyle.fill;

    // ── Teto (concreto industrial) ──
    p.color = const Color(0xFF484848);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.18), p);

    // Dutos
    p.color = const Color(0xFF585858);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.02, w, h * 0.03), p);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.07, w * 0.60, h * 0.025), p);
    p.color = const Color(0xFF404040);
    canvas.drawRect(Rect.fromLTWH(w * 0.15, 0, w * 0.06, h * 0.09), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.50, 0, w * 0.05, h * 0.09), p);

    // Luminárias de teto
    p.color = const Color(0xFFFFF8D0);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w * 0.35) + w * 0.02, h * 0.12, w * 0.28, h * 0.022),
        p,
      );
    }
    p.color = const Color(0xFFFFF8D0).withOpacity(0.10);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w * 0.35), h * 0.12, w * 0.32, h * 0.20),
        p,
      );
    }

    // ── Paredes ──
    p.color = const Color(0xFFB0A888);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.18, w, h * 0.82), p);

    // ── Estantes do fundo ──
    _drawShelfSection(canvas, p, w, h,
        left: 0,
        top: h * 0.18,
        width: w * 0.62,
        height: h * 0.56,
        rows: 5,
        cols: 14,
        seed: 0);

    // Painel separador
    p.color = const Color(0xFF5A3A10);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.18, w * 0.03, h * 0.56), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.62, h * 0.18, w * 0.025, h * 0.56), p);

    // ── Chão (azulejo escuro reflexivo) ──
    p.color = const Color(0xFF2A2A30);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.74, w, h * 0.26), p);
    p.color = const Color(0xFF222228);
    for (int r = 0; r < 6; r++) {
      canvas.drawRect(Rect.fromLTWH(0, h * 0.74 + r * h * 0.045, w, 1), p);
    }
    for (int c = 0; c < 10; c++) {
      canvas.drawRect(Rect.fromLTWH(c * (w / 10), h * 0.74, 1, h * 0.26), p);
    }
    p.color = Colors.white.withOpacity(0.05);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.74, w, h * 0.08), p);

    // ── Mesa redonda + cadeiras ──
    p.color = const Color(0xFF1A1A1A);
    final List<Offset> chairs = [
      Offset(w * 0.08, h * 0.72), Offset(w * 0.15, h * 0.72),
      Offset(w * 0.08, h * 0.79), Offset(w * 0.15, h * 0.79),
    ];
    for (final cp in chairs) {
      canvas.drawRect(Rect.fromLTWH(cp.dx - 12, cp.dy - 12, 22, 22), p);
      canvas.drawRect(Rect.fromLTWH(cp.dx - 12, cp.dy - 22, 22, 10), p);
    }
    p.color = const Color(0xFF8B6914);
    canvas.drawCircle(Offset(w * 0.115, h * 0.755), w * 0.065, p);
    p.color = const Color(0xFF9A7820);
    canvas.drawCircle(Offset(w * 0.115, h * 0.755), w * 0.060, p);

    // ── Banco curvo (puf serpentiforme) ──
    p.color = const Color(0xFFD4C090);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.88), width: w * 0.22, height: h * 0.07),
      p,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.52, h * 0.93), width: w * 0.20, height: h * 0.06),
      p,
    );
    p.color = const Color(0xFFBEAA78);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.88), width: w * 0.18, height: h * 0.05),
      p,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.52, h * 0.93), width: w * 0.16, height: h * 0.04),
      p,
    );

    // ── Banner "Biblioteca Virtual Pearson" ──
    p.color = const Color(0xFF555550);
    canvas.drawRect(Rect.fromLTWH(w * 0.60, h * 0.40, 6, h * 0.36), p);
    p.color = const Color(0xFF1A3A8A);
    canvas.drawRect(Rect.fromLTWH(w * 0.58, h * 0.20, w * 0.10, h * 0.22), p);
    p.color = const Color(0xFF1E4AAA);
    canvas.drawRect(Rect.fromLTWH(w * 0.585, h * 0.205, w * 0.09, h * 0.21), p);

    // Ícone
    p.color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(Offset(w * 0.630, h * 0.250), w * 0.018, p);

    // Textos do banner
    _drawText(canvas, 'Biblioteca', Offset(w * 0.630, h * 0.278),
        const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold, fontFamily: 'PixelifySans'));
    _drawText(canvas, 'Virtual', Offset(w * 0.630, h * 0.290),
        const TextStyle(color: Colors.white, fontSize: 7, fontFamily: 'PixelifySans'));
    _drawText(canvas, 'Pearson', Offset(w * 0.630, h * 0.302),
        const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold, fontFamily: 'PixelifySans'));

    // QR code (placeholder)
    p.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(w * 0.608, h * 0.36, w * 0.04, h * 0.04), p);
    p.color = const Color(0xFF1A3A8A);
    canvas.drawRect(Rect.fromLTWH(w * 0.612, h * 0.362, w * 0.032, h * 0.036), p);

    // ── Estante direita (display de livros) ──
    p.color = const Color(0xFF2A2A2A);
    canvas.drawRect(Rect.fromLTWH(w * 0.70, h * 0.18, w * 0.30, h * 0.56), p);
    p.color = const Color(0xFF5A3A10);
    for (int row = 0; row < 5; row++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.70, h * (0.18 + row * 0.11), w * 0.30, h * 0.015),
        p,
      );
    }

    // Livros na estante direita
    final Random rng = Random(77);
    for (int row = 0; row < 4; row++) {
      for (int b = 0; b < 4; b++) {
        p.color = _bookAt(row * 10 + b + 40);
        double bx = w * 0.715 + b * (w * 0.065);
        double by = h * (0.195 + row * 0.11);
        canvas.drawRect(Rect.fromLTWH(bx, by, w * 0.050, h * 0.09), p);
        p.color = p.color.withOpacity(0.6);
        canvas.drawRect(Rect.fromLTWH(bx, by, w * 0.005, h * 0.09), p);
        rng.nextInt(10);
      }
    }

    // Placa "Sugestões de leitura"
    p.color = const Color(0xFFE8E0D0);
    canvas.drawRect(Rect.fromLTWH(w * 0.72, h * 0.18, w * 0.14, h * 0.04), p);
    _drawText(canvas, 'Sugestões de leitura', Offset(w * 0.79, h * 0.20),
        const TextStyle(color: Color(0xFF333333), fontSize: 6, fontFamily: 'PixelifySans'));

    // Painel elétrico
    p.color = const Color(0xFF606060);
    canvas.drawRect(Rect.fromLTWH(w * 0.94, h * 0.30, w * 0.06, h * 0.15), p);
    p.color = const Color(0xFFCC2200);
    canvas.drawRect(Rect.fromLTWH(w * 0.95, h * 0.31, w * 0.04, h * 0.025), p);
    _drawText(canvas, '⚡', Offset(w * 0.97, h * 0.35),
        const TextStyle(color: Colors.yellow, fontSize: 12));
  }

  void _drawShelfSection(
    Canvas canvas,
    Paint p,
    double w,
    double h, {
    required double left,
    required double top,
    required double width,
    required double height,
    required int rows,
    required int cols,
    required int seed,
  }) {
    p.color = const Color(0xFF5A3A10);
    canvas.drawRect(Rect.fromLTWH(left, top, width, height), p);

    final double shelfH = height / rows;
    final double bookW = (width - 10) / cols;

    for (int r = 0; r < rows; r++) {
      p.color = const Color(0xFF6B4A1A);
      canvas.drawRect(Rect.fromLTWH(left, top + r * shelfH, width, h * 0.012), p);

      for (int c = 0; c < cols; c++) {
        p.color = _bookAt(seed + r * cols + c);
        final double bx = left + 4 + c * bookW;
        final double by = top + r * shelfH + h * 0.015;
        final double bh = shelfH - h * 0.02;
        canvas.drawRect(Rect.fromLTWH(bx, by, bookW - 2, bh), p);
        p.color = p.color.withOpacity(0.5);
        canvas.drawRect(Rect.fromLTWH(bx, by, 2, bh), p);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_) => false;
}