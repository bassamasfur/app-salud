import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../models/enums.dart';
import '../l10n/app_localizations.dart';
import 'pdf_preview_page.dart';

/// Página dedicada para mostrar el plan personalizado premium
/// Incluye peso ideal y plan nutricional
class PlanPersonalizadoPage extends StatelessWidget {
  final Persona persona;

  const PlanPersonalizadoPage({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final pesoIdeal = persona.calcularPesoIdeal();
    final metasCalorias = persona.calcularMetasCalorias();

    // Verificar que tengamos los datos necesarios para las calorías
    if (metasCalorias == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: const Color(0xFF2E86AB),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No se pudieron calcular los datos del plan. Asegúrate de haber completado todos los datos del perfil.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.yourPersonalizedPlan,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Recargar cerrar y volver
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: loc.calculateAnotherImc,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado informativo
                _buildEncabezado(loc, isSmallScreen),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Tarjeta de Peso Ideal
                _buildPesoIdealCard(loc, pesoIdeal, isSmallScreen),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Tarjeta de Plan Nutricional
                _buildPlanNutricionalCard(loc, metasCalorias, isSmallScreen),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Información adicional
                _buildDatosPersonales(loc, isSmallScreen),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // Botones de acción
                _buildBotonesAccion(context, loc, isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEncabezado(AppLocalizations loc, bool isSmallScreen) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: isSmallScreen ? 40 : 48,
              color: Colors.amber.shade600,
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.planGenerated,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    loc.personalizedHealthPlan,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesoIdealCard(
    AppLocalizations loc,
    Map<String, dynamic> pesoIdeal,
    bool isSmallScreen,
  ) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        child: Column(
          children: [
            // Icono y título
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: isSmallScreen ? 32 : 40,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Text(
                  loc.healthyWeightRange,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 20 : 24),

            // Tres valores de peso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPesoItem(
                  loc.minimum,
                  pesoIdeal['pesoMinimo'],
                  Colors.orange.shade400,
                  isSmallScreen,
                ),
                _buildPesoItem(
                  loc.ideal,
                  pesoIdeal['pesoIdeal'],
                  Colors.green.shade500,
                  isSmallScreen,
                ),
                _buildPesoItem(
                  loc.maximum,
                  pesoIdeal['pesoMaximo'],
                  Colors.orange.shade400,
                  isSmallScreen,
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),

            // Mensaje personalizado
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pesoIdeal['mensaje'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 15,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesoItem(
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
            fontSize: isSmallScreen ? 12 : 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          '${peso.toStringAsFixed(1)} kg',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanNutricionalCard(
    AppLocalizations loc,
    Map<String, dynamic> metasCalorias,
    bool isSmallScreen,
  ) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
        child: Column(
          children: [
            // Icono y título
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.orange.shade600,
                  size: isSmallScreen ? 32 : 40,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Text(
                  loc.yourNutritionalPlan,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),

            // TMB y TDEE
            Row(
              children: [
                Expanded(
                  child: _buildMetabolicoCard(
                    loc.basalMetabolism,
                    '${metasCalorias['tmb']} cal',
                    Colors.blue.shade400,
                    Icons.favorite_border,
                    isSmallScreen,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: _buildMetabolicoCard(
                    loc.maintenanceCalories,
                    '${metasCalorias['tdee']} cal',
                    Colors.purple.shade400,
                    Icons.analytics_outlined,
                    isSmallScreen,
                  ),
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),

            // Meta recomendada (destacada)
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.recommendedGoal,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Text(
                    metasCalorias['recomendacion'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    '${metasCalorias['metaRecomendada']} cal/día',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 32 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (metasCalorias['semanasEstimadas'] > 0) ...[
                    SizedBox(height: isSmallScreen ? 10 : 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              loc.weeksToIdealWeight(
                                metasCalorias['semanasEstimadas'],
                              ),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 11 : 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),

            // Otras opciones de calorías
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.otherCalorieOptions,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  _buildOpcionCaloria(
                    '🟢 ${loc.maintainWeight}',
                    metasCalorias['mantenimiento'],
                    null,
                    isSmallScreen,
                  ),
                  _buildOpcionCaloria(
                    '💚 ${loc.moderateWeightLoss}',
                    metasCalorias['perderModerado'],
                    '(-0.5 kg/semana)',
                    isSmallScreen,
                  ),
                  _buildOpcionCaloria(
                    '💙 ${loc.rapidWeightLoss}',
                    metasCalorias['perderRapido'],
                    '(-1 kg/semana)',
                    isSmallScreen,
                  ),
                  _buildOpcionCaloria(
                    '💛 ${loc.gainWeight}',
                    metasCalorias['ganarPeso'],
                    '(+0.3 kg/semana)',
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetabolicoCard(
    String label,
    String valor,
    Color color,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isSmallScreen ? 24 : 28),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              color: Colors.grey[600],
              height: 1.2,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionCaloria(
    String label,
    int calorias,
    String? detalle,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (detalle != null)
                  Text(
                    detalle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '$calorias cal/día',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatosPersonales(AppLocalizations loc, bool isSmallScreen) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue.shade600,
                  size: isSmallScreen ? 20 : 24,
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Text(
                  loc.yourProfile,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            _buildDatoPersonal(
              '${loc.age}',
              '${persona.edad} ${loc.years}',
              Icons.cake,
              isSmallScreen,
            ),
            _buildDatoPersonal(
              '${loc.sex}',
              persona.sexo!.name == 'hombre' ? loc.male : loc.female,
              persona.sexo!.name == 'hombre' ? Icons.male : Icons.female,
              isSmallScreen,
            ),
            _buildDatoPersonal(
              '${loc.activityLevel}',
              persona.nivelActividad!.descripcion,
              Icons.directions_run,
              isSmallScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatoPersonal(
    String label,
    String valor,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        children: [
          Icon(icon, size: isSmallScreen ? 16 : 18, color: Colors.grey[600]),
          SizedBox(width: isSmallScreen ? 8 : 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion(
    BuildContext context,
    AppLocalizations loc,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        // Botón descargar PDF
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 52,
          child: ElevatedButton.icon(
            onPressed: () {
              _mostrarVistaPrevia(context, persona);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(Icons.preview, size: isSmallScreen ? 18 : 20),
            label: Text(
              loc.viewReport,
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        // Botón volver a resultados
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E86AB),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
            label: Text(
              loc.backToResults,
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Método para mostrar la vista previa del PDF antes de descargar
  void _mostrarVistaPrevia(BuildContext context, Persona persona) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFPreviewPage(persona: persona)),
    );
  }
}
