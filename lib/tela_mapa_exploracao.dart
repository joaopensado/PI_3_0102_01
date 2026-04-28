import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class TelaMapaExploracao extends StatefulWidget {
  @override
  _TelaMapaExploracaoState createState() => _TelaMapaExploracaoState();
}

class _TelaMapaExploracaoState extends State<TelaMapaExploracao> {

  final MapController _mapController = MapController();

  double _userLat = -22.834084781581872;
  double _userLng = -47.052650679667536;

  double _zoomAtual = 17;

  final LatLng _h15 = LatLng(-22.834084781581872, -47.052650679667536);

  List<LatLng> _rota = [];

  // 🔥 CONTROLE DA GEOLOCALIZAÇÃO
  StreamSubscription<html.Geoposition>? _geoSubscription;

  // 🔥 TAMANHO DINÂMICO
  double _calcularTamanho(double base) {
    double fator = (20 - _zoomAtual) / 3;
    fator = fator.clamp(0.5, 2.5);
    return base * fator;
  }

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacaoTempoReal();
  }

  // ================= 📡 LOCALIZAÇÃO TEMPO REAL =================
  void _iniciarLocalizacaoTempoReal() {
    final geo = html.window.navigator.geolocation;

    if (geo == null) return;

    _geoSubscription = geo.watchPosition(
      enableHighAccuracy: true,
    ).listen((event) {

      if (!mounted) return;

      final pos = event as html.Geoposition;

      final lat = pos.coords?.latitude?.toDouble();
      final lng = pos.coords?.longitude?.toDouble();

      if (lat != null && lng != null) {
        setState(() {
          _userLat = lat;
          _userLng = lng;
        });

        _mapController.move(
          LatLng(_userLat, _userLng),
          _mapController.camera.zoom,
        );

        _verificarProximidade();
      }
    });
  }

  // ================= 📏 DISTÂNCIA =================
  double _calcularDistancia() {
    return Distance().as(
      LengthUnit.Meter,
      LatLng(_userLat, _userLng),
      _h15,
    );
  }

  // ================= 🎯 CHEGOU =================
  void _verificarProximidade() {
    if (_calcularDistancia() < 30) {
      Navigator.pushReplacementNamed(context, '/h15');
    }
  }

  // ================= 🗺️ ROTA =================
  Future<void> _buscarRota() async {
    final url =
        'https://router.project-osrm.org/route/v1/foot/'
        '$_userLng,$_userLat;${_h15.longitude},${_h15.latitude}'
        '?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final coords = data['routes'][0]['geometry']['coordinates'];

        if (!mounted) return;

        setState(() {
          _rota = coords.map<LatLng>((c) {
            return LatLng(c[1], c[0]);
          }).toList();
        });
      }
    } catch (e) {
      print('Erro rota: $e');
    }
  }

  // ================= 🧹 DISPOSE =================
  @override
  void dispose() {
    _geoSubscription?.cancel(); // 🔥 ESSENCIAL
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // 🗺️ MAPA
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(_userLat, _userLng),
              initialZoom: 17,

              onPositionChanged: (position, hasGesture) {
                if (!mounted) return;
                setState(() {
                  _zoomAtual = position.zoom ?? _zoomAtual;
                });
              },
            ),
            children: [

              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),

              // 🧭 ROTA
              if (_rota.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _rota,
                      strokeWidth: 4,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),

              // 📍 MARCADORES
              MarkerLayer(
                markers: [

                  // 📍 JOGADOR
                  Marker(
                    point: LatLng(_userLat, _userLng),
                    width: _calcularTamanho(40),
                    height: _calcularTamanho(40),
                    child: Image.asset(
                      'assets/personagens/player-masc.png',
                      width: _calcularTamanho(60),
                      height: _calcularTamanho(60),
                    ),
                  ),

                  // 🐧 PINGO
                  Marker(
                    point: _h15,
                    width: _calcularTamanho(60),
                    height: _calcularTamanho(60),
                    child: Image.asset(
                      'assets/personagens/pingo.png',
                      width: _calcularTamanho(80),
                      height: _calcularTamanho(80),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 🎮 HUD
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: Column(
                children: [
                  Text(
                    '🐧 Vá até o Pingo para iniciar o jogo!',
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                  Text(
                    'Distância: ${_calcularDistancia().toStringAsFixed(0)}m',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // 🚀 BOTÃO ROTA
          Positioned(
            bottom: 40,
            right: 20,
            child: GestureDetector(
              onTap: _buscarRota,
              child: _botaoPixelComIcone('ROTA', Icons.alt_route),
            ),
          ),

          // 🔙 BOTÃO VOLTAR
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () async {
                final sair = await showDialog<bool>(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.cyanAccent, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            'SAIR DO JOGO?',
                            style: TextStyle(
                              fontFamily: 'PixelifySans',
                              color: Colors.cyanAccent,
                            ),
                          ),

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              GestureDetector(
                                onTap: () => Navigator.pop(context, false),
                                child: _botaoPixel('CANCELAR', Colors.cyanAccent),
                              ),

                              GestureDetector(
                                onTap: () => Navigator.pop(context, true),
                                child: _botaoPixel('SAIR', Colors.redAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                if (sair == true) Navigator.pop(context);
              },
              child: _botaoPixelComIcone('VOLTAR', Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  // 🔘 BOTÃO PADRÃO
  Widget _botaoPixel(String texto, Color cor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Color(0xFF1a1f3a),
        border: Border.all(color: cor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontFamily: 'PixelifySans',
          fontSize: 11,
          color: cor,
        ),
      ),
    );
  }

  // 🔘 BOTÃO COM ÍCONE
  Widget _botaoPixelComIcone(String texto, IconData icone) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1a1f3a),
        border: Border.all(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.cyanAccent, size: 18),
          SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontFamily: 'PixelifySans',
              fontSize: 12,
              color: Colors.cyanAccent,
            ),
          ),
        ],
      ),
    );
  }
}