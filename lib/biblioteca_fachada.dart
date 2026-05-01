import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'biblioteca_hall.dart';

// ═══════════════════════════════════════════════
//  TELA 1 — Fachada externa da Biblioteca (noite)
// ═══════════════════════════════════════════════
class BibliotecaFachadaScreen extends StatefulWidget {
  const BibliotecaFachadaScreen({super.key});

  @override
  State<BibliotecaFachadaScreen> createState() =>
      _BibliotecaFachadaScreenState();
}

class _BibliotecaFachadaScreenState extends State<BibliotecaFachadaScreen> {
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
          MaterialPageRoute(builder: (_) => const BibliotecaHallScreen()),
        ),
        child: Stack(
          children: [
            // ── Cena pixel art ──
            CustomPaint(
              painter: _FachadaPainter(),
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

            // ── Caixa de diálogo / instrução ──
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
                      'BIBLIOTECA',
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 20,
                        color: Colors.cyanAccent,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Você chegou na entrada da biblioteca.\nO prédio está iluminado na noite calma do campus.',
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
                      '[ TOQUE PARA ENTRAR ]',
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
//  PAINTER — Fachada externa noturna
// ═══════════════════════════════════════════════
class _FachadaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = Paint()..style = PaintingStyle.fill;
    final rng = Random(42);

    // ── Céu noturno ──
    p.color = const Color(0xFF081528);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.62), p);

    // Estrelas
    p.color = Colors.white;
    for (int i = 0; i < 70; i++) {
      final double sz = rng.nextDouble() < 0.6 ? 1.5 : 2.5;
      canvas.drawRect(
        Rect.fromLTWH(
            rng.nextDouble() * w, rng.nextDouble() * h * 0.30, sz, sz),
        p,
      );
    }

    // ── Prédio esquerdo ──
    p.color = const Color(0xFF1E1808);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.07, w * 0.31, h * 0.58), p);
    p.color = const Color(0xFFFFB040).withOpacity(0.35);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.07, w * 0.24, h * 0.56), p);

    // Janelas iluminadas
    p.color = const Color(0xFFFFB840);
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 2; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            w * 0.03 + col * w * 0.10,
            h * 0.11 + row * h * 0.12,
            w * 0.07,
            h * 0.08,
          ),
          p,
        );
      }
    }

    // Pilar frontal
    p.color = const Color(0xFF4A3A18);
    canvas.drawRect(Rect.fromLTWH(w * 0.28, h * 0.22, w * 0.04, h * 0.40), p);

    // ── Estrutura de aço overhead ──
    p.color = const Color(0xFF707060);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.07, w, h * 0.038), p);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.39, w, h * 0.038), p);

    p.color = const Color(0xFF606050);
    const int bays = 7;
    for (int i = 0; i <= bays; i++) {
      final double x = (i / bays) * w;
      canvas.drawRect(Rect.fromLTWH(x - 3, h * 0.07, 6, h * 0.36), p);
    }

    // Diagonais (treliça X)
    p.color = const Color(0xFF888878);
    for (int i = 0; i < bays; i++) {
      final double x1 = (i / bays) * w;
      final double x2 = ((i + 1) / bays) * w;
      final Path d1 = Path()
        ..moveTo(x1, h * 0.07)
        ..lineTo(x2, h * 0.428)
        ..lineTo(x2 + 4, h * 0.428)
        ..lineTo(x1 + 4, h * 0.07)
        ..close();
      canvas.drawPath(d1, p);
      final Path d2 = Path()
        ..moveTo(x2, h * 0.07)
        ..lineTo(x1, h * 0.428)
        ..lineTo(x1 + 4, h * 0.428)
        ..lineTo(x2 + 4, h * 0.07)
        ..close();
      canvas.drawPath(d2, p);
    }

    // Luminárias
    p.color = const Color(0xFFFFFAC8);
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w / 5) + 12, h * 0.39, w * 0.14, h * 0.022),
        p,
      );
    }
    p.color = const Color(0xFFFFFAC8).withOpacity(0.12);
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * (w / 5) + 2, h * 0.39, w * 0.18, h * 0.10),
        p,
      );
    }

    // ── Gramado ──
    p.color = const Color(0xFF14581A);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.58, w * 0.31, h), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.73, h * 0.60, w, h), p);

    // Arbusto
    p.color = const Color(0xFF0E4012);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.60, w * 0.28, h * 0.06), p);

    // ── Calçada central ──
    p.color = const Color(0xFFB0A07A);
    canvas.drawRect(Rect.fromLTWH(w * 0.31, h * 0.52, w * 0.42, h), p);

    // Faixa tátil vermelha
    p.color = const Color(0xFFBB1600);
    canvas.drawRect(Rect.fromLTWH(w * 0.42, h * 0.52, w * 0.038, h), p);

    // ── Cobertura da entrada ──
    p.color = const Color(0xFF303028);
    canvas.drawRect(Rect.fromLTWH(w * 0.37, h * 0.46, w * 0.24, h * 0.10), p);
    p.color = const Color(0xFF484840);
    canvas.drawRect(Rect.fromLTWH(w * 0.39, h * 0.49, w * 0.20, h * 0.05), p);

    // ── Palmeiras ──
    final List<double> tX = [w * 0.55, w * 0.64, w * 0.76, w * 0.88];
    final List<double> tY = [h * 0.24, h * 0.21, h * 0.26, h * 0.30];
    for (int t = 0; t < tX.length; t++) {
      final double tx = tX[t];
      final double ty = tY[t];
      p.color = const Color(0xFF5A3618);
      canvas.drawRect(Rect.fromLTWH(tx - 4, ty, 8, h * 0.38), p);
      p.color = const Color(0xFF226828);
      for (int i = 0; i < 7; i++) {
        final double a = (i / 7.0) * pi * 2;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(tx + cos(a) * 28, ty + sin(a) * 16),
            width: 42,
            height: 16,
          ),
          p,
        );
      }
    }

    // ── Postes de sinalização ──
    p.color = const Color(0xFF1255A0);
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.48, 7, h * 0.22), p);
    p.color = const Color(0xFF1565C0);
    canvas.drawRect(Rect.fromLTWH(w * 0.21, h * 0.48, 14, h * 0.09), p);
    p.color = const Color(0xFF1255A0);
    canvas.drawRect(Rect.fromLTWH(w * 0.41, h * 0.47, 7, h * 0.22), p);
    p.color = const Color(0xFF1565C0);
    canvas.drawRect(Rect.fromLTWH(w * 0.37, h * 0.47, 14, h * 0.08), p);

    // ── Guarda-corpo ──
    p.color = const Color(0xFF989888);
    canvas.drawRect(Rect.fromLTWH(w * 0.71, h * 0.54, 4, h * 0.22), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.78, h * 0.56, 4, h * 0.20), p);
    canvas.drawRect(Rect.fromLTWH(w * 0.71, h * 0.57, w * 0.11, 3), p);
  }

  @override
  bool shouldRepaint(_) => false;
}