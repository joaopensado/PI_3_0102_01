import 'package:flutter/material.dart';
import 'salaPrincipal.dart';
import 'package:audioplayers/audioplayers.dart';

class CorredorScreen extends StatefulWidget {
  const CorredorScreen({super.key});

  @override
  _CorredorScreenState createState() => _CorredorScreenState();
}

class _CorredorScreenState extends State<CorredorScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    // Não toca automaticamente na web; chama após um gesto
    // Se for mobile, pode descomentar: tocarSom();
  }

  Future<void> tocarSom() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/manacas_background_music.mp3'));
      print("Áudio tocando");
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> toggleSom() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/corredor_manacas.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botão de áudio (canto superior direito)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 32,
              ),
              onPressed: toggleSom,
            ),
          ),
          // Botão para iniciar música (adicional para web)
          Positioned(
            top: 100,
            right: 20,
            child: ElevatedButton(
              onPressed: tocarSom,
              child: const Text("Tocar Música"),
            ),
          ),
          // Pegadas clicáveis
          Positioned(
            bottom: 80,
            right: 50,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalaPrincipalScreen()),
                );
              },
              child: Image.asset(
                'assets/fundo/pegadas.png',
                width: 120,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}