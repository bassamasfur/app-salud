import 'package:flutter/material.dart';
// ...import eliminado: google_mobile_ads...
import '../l10n/app_localizations.dart';

/// Página de bienvenida de la aplicación IMC
/// Primera pantalla que ve el usuario con información sobre la app
class BienvenidaPage extends StatelessWidget {
  final void Function(Locale locale) setLocale;
  final Locale? currentLocale;

  const BienvenidaPage({
    super.key,
    required this.setLocale,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isWideScreen = screenWidth > 400;
    String lang =
        (currentLocale?.languageCode ??
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
                setLocale(
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
                    vertical: isSmallScreen ? 12.0 : 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      // ...Banner de AdMob eliminado...
                      Center(
                        child: SizedBox(
                          // ...Widget de AdMob eliminado...
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 20),

                      // Logo/Icono de la aplicación - responsive
                      Container(
                        width: isSmallScreen ? 50 : 60,
                        height: isSmallScreen ? 50 : 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 25 : 30,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.monitor_weight,
                          size: isSmallScreen ? 26 : 32,
                          color: const Color(0xFF2E86AB),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Título principal - responsive
                      Text(
                        loc.appTitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 6 : 8),

                      // Subtítulo - responsive
                      Text(
                        loc.subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // Card con información - responsive
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: isSmallScreen ? 30 : 36,
                                color: const Color(0xFF2E86AB),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Text(
                                loc.whatIsImcTitle,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E86AB),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              Text(
                                loc.whatIsImcDesc,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13 : 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),

                              // Rangos de IMC - responsive
                              Container(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 10 : 12,
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
                                        fontSize: isSmallScreen ? 14 : 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 6 : 8),
                                    _buildRangoIMC(
                                      loc.underweight,
                                      '< 18.5',
                                      Colors.blue,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.normal,
                                      '18.5 - 24.9',
                                      Colors.green,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.overweight,
                                      '25.0 - 29.9',
                                      Colors.orange,
                                      isSmallScreen,
                                    ),
                                    _buildRangoIMC(
                                      loc.obesity,
                                      '≥ 30.0',
                                      Colors.red,
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
                      height: isSmallScreen ? 45 : 50,
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
                              isSmallScreen ? 22 : 25,
                            ),
                          ),
                        ),
                        child: Text(
                          loc.calculateImc,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 15 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Crédito del desarrollador - responsive
                    Text(
                      loc.developedBy,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
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
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 1 : 2),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 10 : 12,
            height: isSmallScreen ? 10 : 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(isSmallScreen ? 5 : 6),
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Expanded(
            child: Text(
              categoria,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            rango,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
