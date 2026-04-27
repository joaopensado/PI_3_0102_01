import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class TelaH15 extends StatefulWidget {
  @override
  _TelaH15State createState() => _TelaH15State();
}

class _TelaH15State extends State<TelaH15> {
  late VideoPlayerController _videoController;
  late VideoPlayerController _videoEsperaController;
  late AudioPlayer _musicPlayer;
  late AudioPlayer _typingSound;
  
  bool _videoInicializado = false;
  bool _videoEsperaInicializado = false;
  bool _audioInicializado = false;
  bool _usandoVideoEspera = false;
  
  // Variáveis para o efeito de digitação
  String _textoExibido = '';
  String _textoCompleto = '';
  int _indiceChar = 0;
  bool _digitando = false;
  
  int etapaDialogo = 0;
  bool missaoAceita = false;
  bool dialogoFinalizado = false;
  String opcaoEscolhida = '';

  @override
  void initState() {
    super.initState();
    _inicializarVideos();
    _inicializarAudios();
  }

  void _inicializarVideos() async {
    // Vídeo principal (falando)
    _videoController = VideoPlayerController.asset('assets/videos/videoPingo.mp4');
    await _videoController.initialize();
    _videoController.setLooping(true);
    
    // Vídeo de espera (quando não está falando)
    _videoEsperaController = VideoPlayerController.asset('assets/videos/videoPingoEsperando.mp4');
    await _videoEsperaController.initialize();
    _videoEsperaController.setLooping(true);
    
    setState(() {
      _videoInicializado = true;
      _videoEsperaInicializado = true;
    });
    
    // Começa com o vídeo de espera
    _mostrarVideoEspera();
  }

void _inicializarAudios() async {
  try {
    _musicPlayer = AudioPlayer();
    _typingSound = AudioPlayer();
    
    await _musicPlayer.setSourceAsset('assets/audio/musicaPingo.mp3');
    await _musicPlayer.setVolume(0.5);
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    
    await _typingSound.setSourceAsset('assets/audio/typingText.mp3');
    await _typingSound.setVolume(0.3);
    
    await _musicPlayer.resume();
    
    print('✅ Áudios carregados com sucesso!');
    setState(() {
      _audioInicializado = true;
    });
  } catch (e) {
    print('❌ Erro ao carregar áudios: $e');
  }
}

  void _mostrarVideoFalando() {
    if (_videoInicializado) {
      _videoEsperaController.pause();
      _videoController.play();
      setState(() {
        _usandoVideoEspera = false;
      });
    }
  }

  void _mostrarVideoEspera() {
    if (_videoEsperaInicializado) {
      _videoController.pause();
      _videoEsperaController.seekTo(Duration.zero);
      _videoEsperaController.play();
      setState(() {
        _usandoVideoEspera = true;
      });
    }
  }

  void _tocarSomDigitacao() {
    if (_audioInicializado) {
      _typingSound.stop();
      _typingSound.resume();
    }
  }

  void _pararSomDigitacao() {
    if (_audioInicializado) {
      _typingSound.stop();
    }
  }

  void _iniciarDigitacao(String novoTexto) {
    // Troca para o vídeo de fala
    _mostrarVideoFalando();
    
    setState(() {
      _textoCompleto = novoTexto;
      _textoExibido = '';
      _indiceChar = 0;
      _digitando = true;
    });
    
    _proximoCaractere();
  }

  void _proximoCaractere() {
    if (_indiceChar < _textoCompleto.length) {
      // Toca som de digitação (exceto espaços e pontuação)
      if (_textoCompleto[_indiceChar] != ' ' && 
          _textoCompleto[_indiceChar] != '\n') {
        _tocarSomDigitacao();
      }
      
      setState(() {
        _textoExibido += _textoCompleto[_indiceChar];
        _indiceChar++;
      });
      
      Future.delayed(Duration(milliseconds: 35), () {
        if (mounted) _proximoCaractere();
      });
    } else {
      // Terminou de digitar - volta para vídeo de espera
      setState(() {
        _digitando = false;
      });
      _pararSomDigitacao();
      _mostrarVideoEspera();
    }
  }

  void _avancarDialogo() {
    if (_digitando) {
      // Pula animação: mostra texto completo e volta para vídeo de espera
      setState(() {
        _textoExibido = _textoCompleto;
        _indiceChar = _textoCompleto.length;
        _digitando = false;
      });
      _pararSomDigitacao();
      _mostrarVideoEspera();
    } else {
      // Avança para próximo diálogo
      setState(() {
        if (etapaDialogo == 0) {
          etapaDialogo = 1;
          _textoExibido = '';
          _textoCompleto = '';
          _indiceChar = 0;
        }
      });
    }
  }

  String get _textoAtualCompleto {
    switch (etapaDialogo) {
      case 0:
        return 'Ei! Você pode me ajudar? Estou com um grande problema...';
      case 1:
        if (opcaoEscolhida == 'ajudar') {
          return 'Sério? Muito obrigado! Eu sabia que podia contar com você!\n\nAcho que outros animais pelo campus podem ter visto algo. Você pode começar procurando na biblioteca.\n\nLembre-se, para receber qualquer informação é necessário cumprir desafios, portanto fique atento às pistas e trate bem os outros animais... Qualquer detalhe pode ser importante!';
        } else if (opcaoEscolhida == 'complicado') {
          return 'Eu entendo... mas por favor, pense bem. Nossa amiga pode estar em perigo.';
        } else {
          return 'Um dos nossos amigos desapareceu, a Capivarilda, a capivara!\n\nNinguém sabe exatamente o que aconteceu, mas ela foi vista pela última vez em algum lugar do campus...\n\nEu tentei procurar sozinho, mas esse lugar é grande demais... preciso de ajuda para encontrar pistas.';
        }
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _videoEsperaController.dispose();
    _musicPlayer.dispose();
    _typingSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/fundo-H15.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          ..._buildPixelDecorations(),

          // VÍDEO DO PINGO - COM BoxFit.cover
          Positioned(
            left: 20,
            bottom: 120,
            child: Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Color(0xFF1a1f3a),
                      border: Border.all(color: Colors.cyanAccent, width: 4),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 20),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _videoInicializado && _videoEsperaInicializado
                          ? FittedBox(
                              fit: BoxFit.cover, // COVER - zoom para preencher tudo
                              child: SizedBox(
                                width: _usandoVideoEspera 
                                    ? _videoEsperaController.value.size.width
                                    : _videoController.value.size.width,
                                height: _usandoVideoEspera
                                    ? _videoEsperaController.value.size.height
                                    : _videoController.value.size.height,
                                child: _usandoVideoEspera
                                    ? VideoPlayer(_videoEsperaController)
                                    : VideoPlayer(_videoController),
                              ),
                            )
                          : Container(
                              color: Color(0xFF0a0e27),
                              child: Center(
                                child: CircularProgressIndicator(color: Colors.cyanAccent),
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF0d1230),
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('PINGO',
                    style: TextStyle(fontFamily: 'PixelifySans', fontSize: 20, color: Colors.cyanAccent),
                  ),
                ),
                Text('O Pinguim Tecnológico',
                  style: TextStyle(fontFamily: 'PixelifySans', fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),

          // BALÃO DE DIÁLOGO
          Positioned(
            right: 20,
            left: 220,
            bottom: 80,
            child: _buildDialogoPixel(),
          ),

          // BOTÃO VOLTAR
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _musicPlayer.stop();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF1a1f3a),
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.cyanAccent, size: 18),
                    SizedBox(width: 6),
                    Text('VOLTAR',
                      style: TextStyle(fontFamily: 'PixelifySans', fontSize: 12, color: Colors.cyanAccent),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogoPixel() {
    if (_textoAtualCompleto.isNotEmpty && _textoCompleto != _textoAtualCompleto && _textoExibido.isEmpty) {
      _iniciarDigitacao(_textoAtualCompleto);
    }

    return GestureDetector(
      onTap: _avancarDialogo,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF0a0e27).withOpacity(0.95),
          border: Border.all(color: Colors.cyanAccent, width: 3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black87, blurRadius: 15, offset: Offset(6, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text('PINGO',
                        style: TextStyle(fontFamily: 'PixelifySans', fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (_digitando)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent)),
                        SizedBox(width: 6),
                        Text('DIGITANDO...', style: TextStyle(fontFamily: 'PixelifySans', fontSize: 9, color: Colors.cyanAccent)),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(_textoExibido,
              style: TextStyle(fontFamily: 'PixelifySans', fontSize: 16, color: Colors.white, height: 1.5),
            ),
            
            if (!_digitando && (etapaDialogo == 0 || (etapaDialogo == 1 && opcaoEscolhida.isEmpty && !dialogoFinalizado)) && _textoExibido == _textoCompleto)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('👆 Toque para continuar...',
                  style: TextStyle(fontFamily: 'PixelifySans', fontSize: 11, color: Colors.cyanAccent.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ),
            
            if (!_digitando && etapaDialogo == 1 && opcaoEscolhida.isEmpty && !dialogoFinalizado && _textoExibido == _textoCompleto)
              Column(
                children: [
                  SizedBox(height: 16),
                  _buildBotaoResposta('"O que aconteceu?"', () {
                    setState(() {
                      opcaoEscolhida = 'ajudar';
                      dialogoFinalizado = true;
                      _textoExibido = '';
                      _textoCompleto = '';
                    });
                  }),
                  SizedBox(height: 10),
                  _buildBotaoResposta('"Isso parece complicado..."', () {
                    setState(() {
                      opcaoEscolhida = 'complicado';
                    });
                  }),
                ],
              ),

            if (!_digitando && etapaDialogo == 1 && opcaoEscolhida == 'complicado' && !missaoAceita && _textoExibido == _textoCompleto)
              Column(
                children: [
                  SizedBox(height: 16),
                  _buildBotaoResposta('ACEITAR MISSÃO', () {
                    setState(() {
                      opcaoEscolhida = 'ajudar';
                      missaoAceita = true;
                      dialogoFinalizado = true;
                    });
                  }),
                ],
              ),

            if (!_digitando && dialogoFinalizado && _textoExibido == _textoCompleto)
              Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      border: Border.all(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('✓ Missão: "Em Busca de Capivarilda" iniciada!',
                            style: TextStyle(fontFamily: 'PixelifySans', color: Colors.greenAccent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBotaoAcao('IR PARA BIBLIOTECA', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Próximo: Biblioteca com Corujito!'), backgroundColor: Colors.purple),
                        );
                      }),
                      _buildBotaoAcao('EXPLORAR H15', () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Explore o H15!'), backgroundColor: Colors.cyan),
                        );
                      }),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoResposta(String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF1a1f3a),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(texto,
          style: TextStyle(fontFamily: 'PixelifySans', fontSize: 13, color: Colors.cyanAccent),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBotaoAcao(String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2a2f4a), Color(0xFF1a1f3a)]),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(texto,
          style: TextStyle(fontFamily: 'PixelifySans', fontSize: 11, color: Colors.cyanAccent),
        ),
      ),
    );
  }

  List<Widget> _buildPixelDecorations() {
    List<Widget> decos = [];
    final codigos = ['01001000 00110001 00110101', '01110000 01111001 01110100', '01101000 01101111 01101110'];
    for (int i = 0; i < codigos.length; i++) {
      decos.add(Positioned(
        top: 30 + (i * 40), right: 10,
        child: Text(codigos[i], style: TextStyle(fontFamily: 'PixelifySans', fontSize: 10, color: Colors.cyanAccent.withOpacity(0.2))),
      ));
    }
    return decos;
  }
}