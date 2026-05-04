import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tela_h15.dart';
import 'arquiteturaOUT.dart';
import 'creditos.dart';
import 'game_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int etapa = 0;
  final AudioPlayer _player = AudioPlayer();
  bool _mutado = false; // NOVO: controle de mute

  @override
  void initState() {
    super.initState();
    tocarAudio();
  }

  Future<void> tocarAudio() async {
    await _player.setVolume(1.0);
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('audio/somtelainicial.mp3'));
  }

  // NOVO: alterna entre mute e unmute
  Future<void> _alternarMute() async {
    setState(() {
      _mutado = !_mutado;
    });
    await _player.setVolume(_mutado ? 0.0 : 1.0);
  }

  // Para o áudio e navega para a rota
  Future<void> _navegarPara(BuildContext context, String rota) async {
    await _player.stop();
    Navigator.pushNamed(context, rota);
  }

  Future<void> _iniciarNovoJogo(BuildContext context) async {
    if (!mounted) return;

    final nome = await _dialogNome(context);

    if (nome == null || nome.isEmpty) return;

    final personagem = await _dialogPersonagem(context);

    if (personagem == null) return;

    await _salvarJogo(nome, personagem);

    await _player.stop();

    Navigator.pushNamed(
      context,
      '/mapa',
      arguments: {
        'nome': nome,
        'personagem': personagem,
      },
    );
  }

  Future<String?> _dialogNome(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0E27),
              border: Border.all(color: Colors.cyanAccent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "NOME DO SAVE",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    color: Colors.cyanAccent,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Digite seu nome...",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildBotaoPixel(
                  "CONFIRMAR",
                  () => Navigator.pop(context, controller.text),
                  true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _dialogPersonagem(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0E27),
              border: Border.all(color: Colors.cyanAccent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ESCOLHA O PERSONAGEM",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 140,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8, // 👈 melhora proporção
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _itemPersonagem(
                          context, 'assets/personagens/player-masc1.png'),
                      _itemPersonagem(
                          context, 'assets/personagens/player-masc2.png'),
                      _itemPersonagem(
                          context, 'assets/personagens/player-fem1.png'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Toque para escolher",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemPersonagem(BuildContext context, String path) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.cyanAccent.withOpacity(0.2),
        onTap: () => Navigator.pop(context, path),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1F3A),
            border: Border.all(color: Colors.cyanAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
              )
            ],
          ),
          padding: EdgeInsets.all(8),
          child: Center(
            child: Image.asset(
              path,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _salvarJogo(String nome, String personagem) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString('saves');
    List saves = [];

    if (dados != null) {
      saves = jsonDecode(dados);
    }

    saves.add({
      'nome': nome,
      'personagem': personagem,
      'fase': '/mapa',
      'lat': null,
      'lng': null,
    });

    await prefs.setString('saves', jsonEncode(saves));
  }

  Future<void> _mostrarSaves(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('saves');

    if (dados == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum save encontrado')),
      );
      return;
    }

    List saves = jsonDecode(dados);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "SEUS SAVES",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    color: Colors.cyanAccent,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                ...List.generate(saves.length, (index) {
                  final save = saves[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    child: Row(
                      children: [
                        // 👤 PERSONAGEM
                        Image.asset(
                          save['personagem'],
                          width: 40,
                        ),

                        SizedBox(width: 10),

                        // 📛 NOME
                        Expanded(
                          child: Text(
                            save['nome'],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PixelifySans',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // ▶️ JOGAR
                        _botaoAcao(
                          icon: Icons.play_arrow,
                          cor: Colors.blue.shade400,
                          onTap: () async {
                            Navigator.pop(context);

                            await _player.stop();

                            Navigator.pushNamed(
                              this.context,
                              save['fase'],
                              arguments: save,
                            );
                          },
                        ),

                        // ✏️ EDITAR
                        _botaoAcao(
                          icon: Icons.edit,
                          cor: Colors.greenAccent,
                          onTap: () {
                            Navigator.pop(context);
                            _editarSave(index, save);
                          },
                        ),

                        // 🗑️ DELETAR
                        _botaoAcao(
                          icon: Icons.delete,
                          cor: Colors.cyanAccent,
                          onTap: () {
                            _confirmarDeletarSave(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "FECHAR",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletarSave(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('saves');

    if (dados == null) return;

    List saves = jsonDecode(dados);

    saves.removeAt(index);

    await prefs.setString('saves', jsonEncode(saves));

    Navigator.of(context).pop();

    await Future.delayed(Duration(milliseconds: 100));

    _mostrarSaves(context);
  }

  Future<void> _confirmarDeletarSave(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0E27),
              border: Border.all(color: Colors.redAccent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.redAccent, size: 40),
                SizedBox(height: 10),
                Text(
                  "DELETAR SAVE?",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ❌ CANCELAR
                    GestureDetector(
                      onTap: () {
                        print("CANCELAR CLICADO");
                        Navigator.pop(dialogContext, false);
                      },
                      child: _buildBotaoPixel(
                        "CANCELAR",
                        () => Navigator.pop(dialogContext, false),
                        true,
                      ),
                    ),

                    // 🗑️ CONFIRMAR
                    GestureDetector(
                      onTap: () => Navigator.pop(dialogContext, true),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red[900],
                          border: Border.all(color: Colors.redAccent, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "DELETAR",
                          style: TextStyle(
                            fontFamily: 'PixelifySans',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmar == true) {
      await _deletarSave(index);
    }
  }

  Future<void> _editarSave(int index, Map save) async {
    TextEditingController controller =
        TextEditingController(text: save['nome']);

    final novoNome = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("EDITAR NOME", style: TextStyle(color: Colors.cyanAccent)),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                _buildBotaoPixel(
                  "SALVAR",
                  () => Navigator.pop(context, controller.text),
                  true,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (novoNome == null) return;

    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('saves');

    List saves = jsonDecode(dados!);

    saves[index]['nome'] = novoNome;

    await prefs.setString('saves', jsonEncode(saves));

    _mostrarSaves(context);
  }

  Future<void> _continuarJogo(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final nome = prefs.getString('nome');
    final personagem = prefs.getString('personagem');

    if (nome == null || personagem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhum save encontrado!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _player.stop();

    Navigator.pushNamed(
      context,
      '/mapa',
      arguments: {
        'nome': nome,
        'personagem': personagem,
      },
    );
  }

  void _mostrarBibliotecaBloqueadaDialogo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E27).withOpacity(0.96),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.cyanAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 18,
                  offset: const Offset(6, 6),
                ),
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.14),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent, width: 2),
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'ACESSO BLOQUEADO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    fontSize: 20,
                    color: Colors.cyanAccent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'biblioteca bloqueada!!!\n\npasse primeiro pelo prédio H15',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F3A),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ENTENDI',
                      style: TextStyle(
                        fontFamily: 'PixelifySans',
                        fontSize: 12,
                        color: Colors.cyanAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          // FUNDO
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo/fundo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ESCURECIMENTO
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // CONTEÚDO
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ARQUIVO\nCAPIVARA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontFamily: 'PixelifySans',
                    height: 1.2,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(4, 4)),
                      Shadow(
                          color: Colors.cyan,
                          blurRadius: 15,
                          offset: Offset(0, 0)),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                _buildBotaoPixel("NOVO JOGO", () {
                  _mostrarEscolhaLocal(context);
                }, false),
                SizedBox(height: 20),
                _buildBotaoPixel("CONTINUAR", () {
                  _mostrarSaves(context);
                }, false),
                SizedBox(height: 15),
                _buildBotaoPixel("CRÉDITOS", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Creditos()),
                  );
                }, true),
              ],
            ),
          ),

          // NOVO: Botão mute/unmute no canto superior direito
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _alternarMute,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4))
                  ],
                ),
                child: Icon(
                  _mutado ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarEscolhaLocal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ESCOLHA O LOCAL",
                  style: TextStyle(
                    fontFamily: 'PixelifySans',
                    fontSize: 18,
                    color: Colors.cyanAccent,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20),
                _buildBotaoPixel("TESTAR NOVO JOGO", () {
                  Navigator.pop(context);

                  Future.microtask(() {
                    _iniciarNovoJogo(this.context);
                  });
                }, true),
                SizedBox(height: 10),
                _buildBotaoPixel("H15 TECNOLOGIA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/h15');
                }, true),
                SizedBox(height: 10),
                _buildBotaoPixel(
                    GameProgress.bibliotecaDesbloqueada
                        ? "BIBLIOTECA"
                        : "BIBLIOTECA 🔒", () {
                  if (!GameProgress.bibliotecaDesbloqueada) {
                    _mostrarBibliotecaBloqueadaDialogo();
                    return;
                  }
                  Navigator.pop(context);
                  _navegarPara(context, '/biblioteca');
                }, true),
                SizedBox(height: 10),
                _buildBotaoPixel("PRAÇA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/refeitorio');
                }, true),
                SizedBox(height: 10),
                _buildBotaoPixel("H12 ARQUITETURA", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/h12');
                }, true),
                SizedBox(height: 10),
                _buildBotaoPixel("MANACÁS (CAVE)", () {
                  Navigator.pop(context);
                  _navegarPara(context, '/manacas');
                }, true),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(
                      fontFamily: 'PixelifySans',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBotaoPixel(String texto, VoidCallback onTap, bool pequeno) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: pequeno ? 10 : 18,
          horizontal: pequeno ? 25 : 55,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(5, 5))],
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: pequeno ? 14 : 18,
            color: Colors.white,
            fontFamily: 'PixelifySans',
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

Widget _botaoAcao({
  required IconData icon,
  required Color cor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F3A),
        border: Border.all(color: cor, width: 2),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Icon(icon, color: cor, size: 18),
    ),
  );
}
