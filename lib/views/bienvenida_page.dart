import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';
import '../services/ad_service.dart';

/// Página de bienvenida de la aplicación IMC
/// Primera pantalla que ve el usuario con información sobre la app
class BienvenidaPage extends StatefulWidget {
  final void Function(Locale locale) setLocale;
  final Locale? currentLocale;

  const BienvenidaPage({
    super.key,
    required this.setLocale,
    required this.currentLocale,
  });

  @override
  State<BienvenidaPage> createState() => _BienvenidaPageState();
}

class _BienvenidaPageState extends State<BienvenidaPage> {
  int _numMediciones = 0;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _cargarNumeroMediciones();
    _loadBannerAd();
  }

  /// Carga el banner de AdMob
  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _isBannerLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        setState(() {
          _isBannerLoaded = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _cargarNumeroMediciones() async {
    final count = await StorageService.contarMediciones();
    if (mounted) {
      setState(() {
        _numMediciones = count;
      });
    }
  }

  Future<void> _navegarAHistorial() async {
    // Navegar y esperar a que vuelva
    await Navigator.pushNamed(context, '/historial');
    // Recargar el contador cuando vuelve
    _cargarNumeroMediciones();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Sistema de 3 niveles para mejor compatibilidad
    final isTinyScreen = screenHeight < 600; // < 5.5" (iPhone SE, Galaxy S5)
    final isSmallScreen =
        screenHeight >= 600 && screenHeight < 680; // 5.5"-6" (S8, Pixel 4a)
    // Para pantallas >= 680px usamos los valores por defecto

    final isWideScreen = screenWidth > 400;
    String lang =
        (widget.currentLocale?.languageCode ??
        Localizations.localeOf(context).languageCode);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'es' ? 'Español' : 'English'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: Icon(Icons.language),
              label: Text(lang == 'es' ? 'ES' : 'EN'),
              onPressed: () {
                widget.setLocale(
                  lang == 'es' ? const Locale('en') : const Locale('es'),
                );
              },
            ),
          ),
        ],
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD), Color(0xFF2E86AB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Contenido principal que se adapta al espacio disponible
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 24.0 : 20.0,
                    vertical: isTinyScreen
                        ? 8.0
                        : (isSmallScreen ? 12.0 : 16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(
                        height: isTinyScreen ? 6 : (isSmallScreen ? 10 : 20),
                      ),

                      // Banner de AdMob
                      if (_isBannerLoaded && _bannerAd != null)
                        Container(
                          alignment: Alignment.center,
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),

                      SizedBox(
                        height: isTinyScreen ? 6 : (isSmallScreen ? 10 : 20),
                      ),

                      // Logo/Icono de la aplicación - responsive
                      Container(
                        width: isTinyScreen ? 45 : (isSmallScreen ? 50 : 60),
                        height: isTinyScreen ? 45 : (isSmallScreen ? 50 : 60),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isTinyScreen ? 22 : (isSmallScreen ? 25 : 30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.monitor_weight,
                          size: isTinyScreen ? 24 : (isSmallScreen ? 26 : 32),
                          color: const Color(0xFF2E86AB),
                        ),
                      ),

                      SizedBox(
                        height: isTinyScreen ? 10 : (isSmallScreen ? 12 : 16),
                      ),

                      // Título principal - responsive
                      Text(
                        loc.appTitle,
                        style: TextStyle(
                          fontSize: isTinyScreen
                              ? 22
                              : (isSmallScreen ? 24 : 28),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        height: isTinyScreen ? 4 : (isSmallScreen ? 6 : 8),
                      ),

                      // Subtítulo - responsive
                      Text(
                        loc.subtitle,
                        style: TextStyle(
                          fontSize: isTinyScreen
                              ? 13
                              : (isSmallScreen ? 14 : 16),
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        height: isTinyScreen ? 12 : (isSmallScreen ? 16 : 20),
                      ),

                      // Card con información - responsive
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            isTinyScreen ? 6.0 : (isSmallScreen ? 8.0 : 14.0),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: isTinyScreen
                                    ? 26
                                    : (isSmallScreen ? 28 : 36),
                                color: const Color(0xFF2E86AB),
                              ),
                              SizedBox(
                                height: isTinyScreen
                                    ? 4
                                    : (isSmallScreen ? 6 : 10),
                              ),
                              Text(
                                loc.whatIsImcTitle,
                                style: TextStyle(
                                  fontSize: isTinyScreen
                                      ? 14
                                      : (isSmallScreen ? 15 : 18),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E86AB),
                                ),
                              ),
                              SizedBox(
                                height: isTinyScreen
                                    ? 3
                                    : (isSmallScreen ? 4 : 6),
                              ),
                              Text(
                                loc.whatIsImcDesc,
                                style: TextStyle(
                                  fontSize: isTinyScreen
                                      ? 11
                                      : (isSmallScreen ? 12 : 14),
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: isTinyScreen
                                    ? 6
                                    : (isSmallScreen ? 8 : 14),
                              ),

                              // Rangos de IMC - responsive
                              Container(
                                padding: EdgeInsets.all(
                                  isTinyScreen ? 6 : (isSmallScreen ? 8 : 12),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      loc.imcRanges,
                                      style: TextStyle(
                                        fontSize: isTinyScreen
                                            ? 12
                                            : (isSmallScreen ? 13 : 15),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(
                                      height: isTinyScreen
                                          ? 3
                                          : (isSmallScreen ? 4 : 6),
                                    ),
                                    _buildRangoIMC(
                                      loc.underweight,
                                      '< 18.5',
                                      Colors.blue,
                                      isTinyScreen,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.normal,
                                      '18.5 - 24.9',
                                      Colors.green,
                                      isTinyScreen,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.overweight,
                                      '25.0 - 29.9',
                                      Colors.orange,
                                      isTinyScreen,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.obesity,
                                      '≥ 30.0',
                                      Colors.red,
                                      isTinyScreen,
                                      isSmallScreen,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sección inferior fija con botón y créditos
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 24.0 : 20.0,
                  vertical: isSmallScreen ? 12.0 : 16.0,
                ),
                child: Column(
                  children: [
                    // Botón para comenzar - responsive
                    SizedBox(
                      width: double.infinity,
                      height: isTinyScreen ? 42 : (isSmallScreen ? 45 : 50),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/formulario');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2E86AB),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTinyScreen ? 21 : (isSmallScreen ? 22 : 25),
                            ),
                          ),
                        ),
                        child: Text(
                          loc.calculateImc,
                          style: TextStyle(
                            fontSize: isTinyScreen
                                ? 14
                                : (isSmallScreen ? 15 : 16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isTinyScreen ? 6 : (isSmallScreen ? 8 : 12),
                    ),

                    // Botón de historial - siempre visible
                    SizedBox(
                      width: double.infinity,
                      height: isTinyScreen ? 42 : (isSmallScreen ? 45 : 50),
                      child: ElevatedButton.icon(
                        onPressed: _numMediciones > 0
                            ? _navegarAHistorial
                            : null, // Deshabilitado si no hay mediciones
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _numMediciones > 0
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.1),
                          foregroundColor: _numMediciones > 0
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          elevation: _numMediciones > 0 ? 2 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTinyScreen ? 21 : (isSmallScreen ? 22 : 25),
                            ),
                            side: BorderSide(
                              color: _numMediciones > 0
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        icon: _numMediciones > 0
                            ? Badge(
                                label: Text('$_numMediciones'),
                                child: Icon(
                                  Icons.history,
                                  size: isTinyScreen ? 18 : 20,
                                ),
                              )
                            : Icon(Icons.history, size: isTinyScreen ? 18 : 20),
                        label: Text(
                          loc.viewHistory,
                          style: TextStyle(
                            fontSize: isTinyScreen
                                ? 14
                                : (isSmallScreen ? 15 : 16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isTinyScreen ? 6 : (isSmallScreen ? 8 : 12),
                    ),

                    // Crédito del desarrollador - responsive
                    Text(
                      loc.developedBy,
                      style: TextStyle(
                        fontSize: isTinyScreen ? 10 : (isSmallScreen ? 11 : 12),
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget helper para mostrar los rangos de IMC - responsive
  Widget _buildRangoIMC(
    String categoria,
    String rango,
    Color color,
    bool isTinyScreen,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTinyScreen ? 0.3 : (isSmallScreen ? 0.5 : 2),
      ),
      child: Row(
        children: [
          Container(
            width: isTinyScreen ? 9 : (isSmallScreen ? 10 : 12),
            height: isTinyScreen ? 9 : (isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(
                isTinyScreen ? 4.5 : (isSmallScreen ? 5 : 6),
              ),
            ),
          ),
          SizedBox(width: isTinyScreen ? 5 : (isSmallScreen ? 6 : 8)),
          Expanded(
            child: Text(
              categoria,
              style: TextStyle(
                fontSize: isTinyScreen ? 10 : (isSmallScreen ? 11 : 13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            rango,
            style: TextStyle(
              fontSize: isTinyScreen ? 10 : (isSmallScreen ? 11 : 13),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
