import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'biblioteca_principal.dart';

// ═══════════════════════════════════════════════
//  TELA 2 — Hall / Armários da Biblioteca
// ═══════════════════════════════════════════════
class BibliotecaHallScreen extends StatefulWidget {
  const BibliotecaHallScreen({super.key});

  @override
  State<BibliotecaHallScreen> createState() => _BibliotecaHallScreenState();
}

class _BibliotecaHallScreenState extends State<BibliotecaHallScreen> {
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
          MaterialPageRoute(builder: (_) => const BibliotecaPrincipalScreen()),
        ),
        child: Stack(
          children: [
            // ── Cena pixel art ──
            CustomPaint(
              painter: _HallPainter(),
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
                      'HALL DE ENTRADA',
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 20,
                        color: Colors.cyanAccent,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Você está no hall da biblioteca.\nArmários azuis alinham-se à esquerda. A saída está à direita.',
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
                      '[ TOQUE PARA AVANÇAR ]',
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

// ═══════════════════════════════════════════════
//  PAINTER — Hall com armários
// ═══════════════════════════════════════════════
class _HallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..style = PaintingStyle.fill;

    // ── Teto e paredes ──
    p.color = const Color(0xFF505055);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.18), p);
    p.color = const Color(0xFFB0B0AA);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.18, w, h * 0.82), p);

    // Dutos no teto
    p.color = const Color(0xFF606065);
    canvas.drawRect(Rect.fromLTWH(w * 0.10, h * 0.03, w * 0.80, h * 0.03), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.25, 0, w * 0.08, h * 0.08), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.65, 0, w * 0.06, h * 0.08), p);

    // Luminárias
    p.color = const Color(0xFFFFFAE0);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w / 4) + w * 0.02, h * 0.10, w * 0.20, h * 0.025),
        p,
      );
    }
    p.color = const Color(0xFFFFFAE0).withOpacity(0.08);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w / 4), h * 0.10, w * 0.24, h * 0.15),
        p,
      );
    }

    // ── Parede lateral esquerda (estrutura dos armários) ──
    p.color = const Color(0xFF1A1A28);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.14, w * 0.30, h * 0.86), p);

    // Armários azuis — grid
    const int cols = 3;
    const int rows = 6;
    const double lockerW = 0.085;
    const double lockerH = 0.12;
    const double startX = 0.010;
    const double startY = 0.16;
    const double gapX = 0.090;
    const double gapY = 0.125;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // Corpo do armário
        p.color = const Color(0xFF1565C0);
        canvas.drawRect(
          Rect.fromLTWH(
            w * (startX + c * gapX),
            h * (startY + r * gapY),
            w * lockerW,
            h * lockerH,
          ),
          p,
        );
        // Borda escura superior
        p.color = const Color(0xFF0D3D80);
        canvas.drawRect(
          Rect.fromLTWH(
            w * (startX + c * gapX),
            h * (startY + r * gapY),
            w * lockerW,
            1.5,
          ),
          p,
        );
        // Borda escura esquerda
        canvas.drawRect(
          Rect.fromLTWH(
            w * (startX + c * gapX),
            h * (startY + r * gapY),
            1.5,
            h * lockerH,
          ),
          p,
        );
        // Puxador dourado
        p.color = const Color(0xFFD4AF37);
        canvas.drawRect(
          Rect.fromLTWH(
            w * (startX + c * gapX + lockerW * 0.78),
            h * (startY + r * gapY + lockerH * 0.35),
            4,
            h * lockerH * 0.30,
          ),
          p,
        );
      }
    }

    // ── Chão ──
    p.color = const Color(0xFF3A3A45);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), p);

    // Grade de azulejos
    p.color = const Color(0xFF2E2E38);
    for (int r = 0; r < 5; r++) {
      canvas.drawRect(Rect.fromLTWH(0, h * 0.75 + r * h * 0.05, w, 1), p);
    }
    for (int c = 0; c < 8; c++) {
      canvas.drawRect(Rect.fromLTWH(c * (w / 8), h * 0.75, 1, h * 0.25), p);
    }

    // Reflexo no chão
    p.color = Colors.white.withOpacity(0.04);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), p);

    // ── Piso tátil (vermelho + amarelo) ──
    p.color = const Color(0xFFCC1A00);
    canvas.drawRect(Rect.fromLTWH(w * 0.28, h * 0.76, w * 0.50, h * 0.055), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.28, h * 0.76, w * 0.055, h * 0.24), p);
    p.color = const Color(0xFFFFCC00);
    canvas.drawRect(Rect.fromLTWH(w * 0.28, h * 0.76, w * 0.06, h * 0.06), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.60, h * 0.76, w * 0.06, h * 0.06), p);

    // ── Parede do fundo ──
    p.color = const Color(0xFF989890);
    canvas.drawRect(Rect.fromLTWH(w * 0.30, h * 0.18, w * 0.55, h * 0.57), p);

    // ── Balcão de atendimento ──
    p.color = const Color(0xFFD8D0B0);
    canvas.drawRect(Rect.fromLTWH(w * 0.32, h * 0.50, w * 0.45, h * 0.06), p);
    p.color = const Color(0xFFE8E0C0);
    canvas.drawRect(Rect.fromLTWH(w * 0.32, h * 0.50, w * 0.45, h * 0.015), p);
    p.color = const Color(0xFF8A8278);
    canvas.drawRect(Rect.fromLTWH(w * 0.32, h * 0.20, w * 0.45, h * 0.30), p);

    // Quadros na parede do balcão
    p.color = const Color(0xFF6A6258);
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.34 + i * w * 0.085, h * 0.22, w * 0.06, h * 0.10),
        p,
      );
      p.color = const Color(0xFF7A6E60);
      canvas.drawRect(
        Rect.fromLTWH(w * 0.342 + i * w * 0.085, h * 0.222, w * 0.056, h * 0.096),
        p,
      );
      p.color = const Color(0xFF6A6258);
    }

    // Silhuetas de funcionários
    p.color = const Color(0xFF3A3028);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.42, h * 0.44), width: 20, height: 22), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.41, h * 0.45, 20, h * 0.05), p);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.60, h * 0.43), width: 20, height: 22), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.59, h * 0.44, 20, h * 0.06), p);

    // Mesinha lateral
    p.color = const Color(0xFFB89860);
    canvas.drawRect(Rect.fromLTWH(w * 0.55, h * 0.55, w * 0.08, h * 0.10), p);
    p.color = const Color(0xFF1565C0);
    canvas.drawRect(Rect.fromLTWH(w * 0.56, h * 0.52, w * 0.06, h * 0.04), p);

    // ── Porta SAÍDA (direita) ──
    p.color = const Color(0xFF707060);
    canvas.drawRect(Rect.fromLTWH(w * 0.80, h * 0.18, w * 0.18, h * 0.57), p);
    p.color = const Color(0xFFB8D8D0).withOpacity(0.7);
    canvas.drawRect(Rect.fromLTWH(w * 0.82, h * 0.20, w * 0.14, h * 0.53), p);
    p.color = const Color(0xFF888880);
    canvas.drawRect(Rect.fromLTWH(w * 0.80, h * 0.18, w * 0.18, h * 0.014), p);

    // Placa SAÍDA
    p.color = const Color(0xFF00AA44);
    canvas.drawRect(Rect.fromLTWH(w * 0.83, h * 0.195, w * 0.10, h * 0.038), p);
    _drawText(
      canvas, 'SAÍDA', Offset(w * 0.88, h * 0.214),
      const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        fontFamily: 'PixelifySans',
      ),
    );

    // ── Cruz na parede ──
    p.color = const Color(0xFF8B4513);
    canvas.drawRect(Rect.fromLTWH(w * 0.96, h * 0.22, 8, h * 0.14), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.935, h * 0.255, w * 0.06, 8), p);

    // ── Extintor ──
    p.color = const Color(0xFFCC1100);
    canvas.drawRect(Rect.fromLTWH(w * 0.77, h * 0.60, 14, h * 0.10), p);
    p.color = const Color(0xFF880A00);
    canvas.drawRect(Rect.fromLTWH(w * 0.77, h * 0.60, 14, h * 0.02), p);
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