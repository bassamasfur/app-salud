import 'package:flutter/material.dart';
import '../controllers/imc_controller.dart';
import 'pdf_preview_page.dart';
import '../l10n/app_localizations.dart';

/// Página que muestra los resultados del cálculo del IMC
/// Incluye el valor, categoría, recomendaciones y opciones de acción
class ResultadoPage extends StatelessWidget {
  const ResultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador pasado como argumento
    final IMCController controller =
        ModalRoute.of(context)!.settings.arguments as IMCController;

    // Verificar que tenemos datos válidos
    if (controller.persona == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: const Color(0xFF2E86AB),
        ),
        body: const Center(child: Text('No hay datos para mostrar')),
      );
    }

    final persona = controller.persona!; // Safe access after null check

    // Obtener dimensiones de pantalla para responsividad
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isWideScreen = screenWidth > 400;

    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.resultTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: isSmallScreen ? 22 : 24),
            onPressed: () {
              // Limpiar datos y volver al formulario
              controller.limpiarDatos();
              Navigator.pushReplacementNamed(context, '/formulario');
            },
            tooltip: loc.newCalculation,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E86AB), Color(0xFF4A90E2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Contenido principal que se adapta al espacio
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 24.0 : 20.0,
                    vertical: isSmallScreen ? 12.0 : 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isSmallScreen ? 4 : 8),

                      // Saludo personalizado
                      _buildSaludo(persona, isSmallScreen, loc),

                      SizedBox(height: isSmallScreen ? 8 : 12),

                      // Card principal con resultados
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Column(
                            children: [
                              // Valor del IMC
                              _buildValorIMC(persona, isSmallScreen, loc),

                              SizedBox(height: isSmallScreen ? 12 : 16),

                              // Categoría del IMC
                              _buildCategoriaIMC(persona, isSmallScreen, loc),

                              SizedBox(height: isSmallScreen ? 12 : 16),

                              // Interpretación solo si la categoría es normal, sobrepeso, bajo peso u obesidad
                              if ([
                                loc.underweight.toLowerCase(),
                                loc.normal.toLowerCase(),
                                loc.overweight.toLowerCase(),
                                loc.obesity.toLowerCase(),
                              ].contains(
                                persona.obtenerCategoriaIMC().toLowerCase(),
                              ))
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                    bottom: isSmallScreen ? 12 : 16,
                                  ),
                                  padding: EdgeInsets.all(
                                    isSmallScreen ? 14 : 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.interpretation,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800],
                                          fontSize: isSmallScreen ? 14 : 15,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 6 : 8),
                                      Text(
                                        _getDescripcionCategoria(
                                          persona.obtenerCategoriaIMC(),
                                          loc,
                                        ),
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 13 : 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Recomendaciones
                              _buildRecomendaciones(
                                persona,
                                isSmallScreen,
                                loc,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción fijos en la parte inferior
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 24.0 : 20.0,
                  vertical: isSmallScreen ? 12.0 : 16.0,
                ),
                child: Column(
                  children: [
                    // Botón calcular otro IMC
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 45 : 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.limpiarDatos();
                          Navigator.pushReplacementNamed(
                            context,
                            '/formulario',
                          );
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
                        icon: Icon(
                          Icons.refresh,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        label: Text(
                          loc.calculateAnotherImc,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 15 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Botón descargar PDF
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 45 : 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _mostrarVistaPrevia(context, persona);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 22 : 25,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.preview,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        label: Text(
                          loc.viewReport,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 15 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Botón volver al inicio
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 40 : 45,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/bienvenida',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 20 : 22,
                            ),
                          ),
                        ),
                        icon: Icon(Icons.home, size: isSmallScreen ? 16 : 18),
                        label: Text(
                          loc.backToHome,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  /// Widget para mostrar el saludo personalizado
  Widget _buildSaludo(persona, bool isSmallScreen, AppLocalizations loc) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            size: isSmallScreen ? 20 : 24,
            color: Colors.white,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.greeting(persona.nombre),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  loc.evaluationResults,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar el valor del IMC
  Widget _buildValorIMC(persona, bool isSmallScreen, AppLocalizations loc) {
    return Row(
      children: [
        // Círculo del IMC más pequeño
        Container(
          width: isSmallScreen ? 80 : 90,
          height: isSmallScreen ? 80 : 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getColorCategoria(persona.obtenerCategoriaIMC()),
                _getColorCategoria(
                  persona.obtenerCategoriaIMC(),
                ).withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _getColorCategoria(
                  persona.obtenerCategoriaIMC(),
                ).withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              persona.calcularIMC().toStringAsFixed(1),
              style: TextStyle(
                fontSize: isSmallScreen ? 22 : 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(width: isSmallScreen ? 16 : 20),

        // Información del IMC al lado
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.yourImcIs,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 6),
              Text(
                _getCategoriaLocalizada(persona.obtenerCategoriaIMC(), loc),
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: _getColorCategoria(persona.obtenerCategoriaIMC()),
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                loc.weightWithUnit(persona.peso.toStringAsFixed(1)),
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 13,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                loc.heightWithUnit(persona.altura.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget para mostrar la categoría del IMC
  Widget _buildCategoriaIMC(persona, bool isSmallScreen, AppLocalizations loc) {
    final categoria = persona.obtenerCategoriaIMC();
    final categoriaLocalizada = _getCategoriaLocalizada(categoria, loc);
    final color = _getColorCategoria(categoria);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(
            _getIconCategoria(categoria),
            size: isSmallScreen ? 32 : 36,
            color: color,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            categoriaLocalizada,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          Text(
            _getDescripcionCategoria(categoria, loc),
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar las recomendaciones
  Widget _buildRecomendaciones(
    persona,
    bool isSmallScreen,
    AppLocalizations loc,
  ) {
    final recomendaciones = _getRecomendaciones(
      persona.obtenerCategoriaIMC(),
      loc,
    );

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue[600],
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Text(
                loc.recommendations,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...recomendaciones.map(
            (recomendacion) => Padding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
                    width: isSmallScreen ? 4 : 6,
                    height: isSmallScreen ? 4 : 6,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Text(
                      recomendacion,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        color: Colors.grey[700],
                        height: 1.4,
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

  /// Obtiene el color según la categoría del IMC
  Color _getColorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'sobrepeso':
        return Colors.orange;
      case 'obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene el ícono según la categoría del IMC
  IconData _getIconCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return Icons.trending_down;
      case 'normal':
        return Icons.check_circle;
      case 'sobrepeso':
        return Icons.trending_up;
      case 'obesidad':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  /// Obtiene la descripción según la categoría del IMC
  String _getDescripcionCategoria(String categoria, AppLocalizations loc) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.descUnderweight;
      case 'normal':
        return loc.descNormal;
      case 'sobrepeso':
        return loc.descOverweight;
      case 'obesidad':
        return loc.descObesity;
      default:
        return loc.descDefault;
    }
  }

  /// Obtiene las recomendaciones según la categoría del IMC
  List<String> _getRecomendaciones(String categoria, AppLocalizations loc) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.recommendationsUnderweight.split('|');
      case 'normal':
        return loc.recommendationsNormal.split('|');
      case 'sobrepeso':
        return loc.recommendationsOverweight.split('|');
      case 'obesidad':
        return loc.recommendationsObesity.split('|');
      default:
        return [loc.recommendationsDefault];
    }
  }

  /// Método para mostrar la vista previa del PDF antes de descargar
  void _mostrarVistaPrevia(BuildContext context, persona) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PDFPreviewPage(persona: persona)),
    );
  }

  /// Devuelve la categoría localizada según el idioma
  String _getCategoriaLocalizada(String categoria, AppLocalizations loc) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.underweight;
      case 'normal':
        return loc.normal;
      case 'sobrepeso':
        return loc.overweight;
      case 'obesidad':
        return loc.obesity;
      default:
        return categoria;
    }
  }
}
