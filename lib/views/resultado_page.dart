import 'package:flutter/material.dart';
import '../controllers/imc_controller.dart';
import 'pdf_preview_page.dart';
import 'datos_adicionales_page.dart';
import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../services/storage_service.dart';

/// Página que muestra los resultados del cálculo del IMC
/// Incluye el valor, categoría, recomendaciones y opciones de acción
/// PREMIUM: También muestra peso ideal y plan de calorías
class ResultadoPage extends StatefulWidget {
  const ResultadoPage({super.key});

  @override
  State<ResultadoPage> createState() => _ResultadoPageState();
}

class _ResultadoPageState extends State<ResultadoPage> {
  final PurchaseService _purchaseService = PurchaseService();

  @override
  void initState() {
    super.initState();
    _purchaseService.initialize();
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  /// Guarda la medición actual en el historial
  Future<void> _guardarMedicion(
    BuildContext context,
    IMCController controller,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final isPremium = _purchaseService.hasPurchased;

    if (controller.persona == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorSavingMeasurement),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final exito = await StorageService.guardarMedicion(
      controller.persona!,
      isPremium,
    );

    if (context.mounted) {
      Navigator.pop(context); // Cerrar el indicador de carga

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(loc.measurementSaved)),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: loc.viewHistory,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushNamed(context, '/historial');
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.errorSavingMeasurement),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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

                      // CONTENIDO PREMIUM: Paywall o features desbloqueadas
                      if (_purchaseService.hasPurchased)
                        _buildPremiumContent(loc, persona, isSmallScreen)
                      else
                        _buildPaywall(loc, isSmallScreen),
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

                    // Botón guardar medición
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 45 : 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _guardarMedicion(context, controller);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 22 : 25,
                            ),
                          ),
                        ),
                        icon: Icon(Icons.save, size: isSmallScreen ? 18 : 20),
                        label: Text(
                          loc.saveMeasurement,
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

  // ============================================
  // MÉTODOS PREMIUM
  // ============================================

  /// Construye el contenido premium completo
  Widget _buildPremiumContent(
    AppLocalizations loc,
    persona,
    bool isSmallScreen,
  ) {
    // Si faltan datos adicionales, mostrar botón para ir al formulario
    if (persona.edad == null ||
        persona.sexo == null ||
        persona.nivelActividad == null) {
      return _buildBotonDatosAdicionales(loc, isSmallScreen);
    }

    final pesoIdeal = persona.calcularPesoIdeal();
    final metasCalorias = persona.calcularMetasCalorias(loc);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 24),
      child: Column(
        children: [
          // Card de Peso Ideal
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: isSmallScreen ? 40 : 48,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 16),
                  Text(
                    'Rango de Peso Saludable',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPesoInfo(
                        'Mínimo',
                        pesoIdeal['pesoMinimo'],
                        Colors.orange,
                        isSmallScreen,
                      ),
                      _buildPesoInfo(
                        'Ideal',
                        pesoIdeal['pesoIdeal'],
                        Colors.green,
                        isSmallScreen,
                      ),
                      _buildPesoInfo(
                        'Máximo',
                        pesoIdeal['pesoMaximo'],
                        Colors.orange,
                        isSmallScreen,
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pesoIdeal['mensaje'],
                      style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: isSmallScreen ? 8 : 12),

          // Card de Plan de Calorías
          if (metasCalorias != null)
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: isSmallScreen ? 40 : 48,
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 16),
                    Text(
                      'Tu Plan Nutricional',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // TMB y TDEE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCaloriaInfo(
                          'Metabolismo\nBasal',
                          metasCalorias['tmb'],
                          Colors.blue,
                          isSmallScreen,
                        ),
                        _buildCaloriaInfo(
                          'Calorías de\nMantenimiento',
                          metasCalorias['tdee'],
                          Colors.purple,
                          isSmallScreen,
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // Meta Recomendada
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🎯 META RECOMENDADA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          Text(
                            metasCalorias['recomendacion'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          Text(
                            '${metasCalorias['metaRecomendada']} cal/día',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 28 : 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (metasCalorias['semanasEstimadas'] > 0) ...[
                            SizedBox(height: isSmallScreen ? 4 : 8),
                            Text(
                              '⏱️ Alcanzarás tu peso ideal en ~${metasCalorias['semanasEstimadas']} semanas',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // Otras opciones
                    Text(
                      'Otras opciones:',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    _buildOpcionCaloria(
                      '🟢 ${loc.maintainWeight}',
                      metasCalorias['mantenimiento'],
                      null,
                      isSmallScreen,
                      loc,
                    ),
                    _buildOpcionCaloria(
                      '💚 ${loc.moderateWeightLoss}',
                      metasCalorias['perderModerado'],
                      loc.weeklyChangeModerate,
                      isSmallScreen,
                      loc,
                    ),
                    _buildOpcionCaloria(
                      '💙 ${loc.rapidWeightLoss}',
                      metasCalorias['perderRapido'],
                      loc.weeklyChangeRapid,
                      isSmallScreen,
                      loc,
                    ),
                    _buildOpcionCaloria(
                      '💛 ${loc.gainWeight}',
                      metasCalorias['ganarPeso'],
                      loc.weeklyChangeGain,
                      isSmallScreen,
                      loc,
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: isSmallScreen ? 12 : 16),
        ],
      ),
    );
  }

  /// Construye el paywall para usuarios sin premium
  Widget _buildPaywall(AppLocalizations loc, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 24,
        vertical: isSmallScreen ? 8 : 12,
      ),
      child: Card(
        elevation: 8,
        color: Colors.amber.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.amber.shade200, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            children: [
              Icon(
                Icons.lock,
                size: isSmallScreen ? 40 : 48,
                color: Colors.amber.shade700,
              ),
              SizedBox(height: isSmallScreen ? 8 : 16),
              Text(
                loc.unlockFullPlan,
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                loc.discoverIdealWeight,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildFeatureLine(loc.featureMinMaxWeight, isSmallScreen),
              _buildFeatureLine(loc.featureDailyCalories, isSmallScreen),
              _buildFeatureLine(loc.featureTimeToGoal, isSmallScreen),
              _buildFeatureLine(loc.featureMultipleScenarios, isSmallScreen),
              _buildFeatureLine(loc.featureOneTimePurchase, isSmallScreen),
              SizedBox(height: isSmallScreen ? 16 : 24),
              SizedBox(
                width: double.infinity,
                height: isSmallScreen ? 45 : 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await _purchaseService.buyProduct();
                    if (!success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.purchaseError)),
                      );
                    } else if (mounted) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 22 : 25,
                      ),
                    ),
                  ),
                  child: Text(
                    _purchaseService.productDetails != null
                        ? loc.oneTimePayment(
                            _purchaseService.productDetails!.price,
                          )
                        : loc.oneTimePayment('\$1.99'),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              TextButton(
                onPressed: () async {
                  await _purchaseService.restorePurchases();
                  if (mounted) setState(() {});
                },
                child: Text(
                  loc.restorePurchase,
                  style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un botón para navegar al formulario de datos adicionales
  Widget _buildBotonDatosAdicionales(AppLocalizations loc, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 24,
        vertical: isSmallScreen ? 8 : 12,
      ),
      child: SizedBox(
        width: double.infinity,
        height: isSmallScreen ? 50 : 56,
        child: ElevatedButton.icon(
          onPressed: () async {
            final IMCController controller =
                ModalRoute.of(context)!.settings.arguments as IMCController;

            // Navegar a la página de datos adicionales
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DatosAdicionalesPage(personaActual: controller.persona!),
              ),
            );
          },
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: Text(
            loc.personalizedProfile,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildPesoInfo(
    String label,
    double peso,
    Color color,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: isSmallScreen ? 12 : 13,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${peso.toStringAsFixed(1)} kg',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriaInfo(
    String label,
    int calorias,
    Color color,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: isSmallScreen ? 11 : 12,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          '$calorias cal',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildOpcionCaloria(
    String label,
    int calorias,
    String? detalle,
    bool isSmallScreen,
    AppLocalizations loc,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
                if (detalle != null)
                  Text(
                    detalle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '$calorias ${loc.calPerDay}',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureLine(String text, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 8 : 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          ),
        ],
      ),
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
