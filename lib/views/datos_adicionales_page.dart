import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/persona.dart';
import '../l10n/app_localizations.dart';
import 'plan_personalizado_page.dart';

/// Página dedicada para recopilar datos adicionales del usuario
/// Necesarios para calcular peso ideal y plan de calorías
class DatosAdicionalesPage extends StatefulWidget {
  final Persona personaActual;

  const DatosAdicionalesPage({super.key, required this.personaActual});

  @override
  State<DatosAdicionalesPage> createState() => _DatosAdicionalesPageState();
}

class _DatosAdicionalesPageState extends State<DatosAdicionalesPage> {
  late int _edad;
  late Sexo _sexo;
  late NivelActividad _nivelActividad;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar con valores existentes o defaults
    _edad = widget.personaActual.edad ?? 30;
    _sexo = widget.personaActual.sexo ?? Sexo.hombre;
    _nivelActividad =
        widget.personaActual.nivelActividad ?? NivelActividad.ligero;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.completeYourProfile,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
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
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header informativo
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: isSmallScreen ? 32 : 40,
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          Expanded(
                            child: Text(
                              loc.profileDescription,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Formulario
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo Edad
                          Text(
                            loc.age,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: loc.yourAgeInYears,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixText: loc.years,
                              prefixIcon: const Icon(Icons.cake),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: _edad.toString(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.pleaseEnterAge;
                              }
                              final edad = int.tryParse(value);
                              if (edad == null || edad <= 0 || edad > 120) {
                                return loc.ageRange;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                setState(() {
                                  _edad = parsed;
                                });
                              }
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 28),

                          // Campo Sexo
                          Text(
                            loc.sex,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sexo = Sexo.hombre;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 12 : 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _sexo == Sexo.hombre
                                          ? Colors.blue[100]
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _sexo == Sexo.hombre
                                            ? Colors.blue
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.male,
                                          size: isSmallScreen ? 32 : 40,
                                          color: _sexo == Sexo.hombre
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          loc.male,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: _sexo == Sexo.hombre
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: _sexo == Sexo.hombre
                                                ? Colors.blue
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 12 : 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sexo = Sexo.mujer;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 12 : 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _sexo == Sexo.mujer
                                          ? Colors.pink[100]
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _sexo == Sexo.mujer
                                            ? Colors.pink
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.female,
                                          size: isSmallScreen ? 32 : 40,
                                          color: _sexo == Sexo.mujer
                                              ? Colors.pink
                                              : Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          loc.female,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: _sexo == Sexo.mujer
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: _sexo == Sexo.mujer
                                                ? Colors.pink
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 28),

                          // Campo Nivel de Actividad
                          Text(
                            loc.physicalActivityLevel,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          DropdownButtonFormField<NivelActividad>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.directions_run),
                            ),
                            // ignore: deprecated_member_use
                            value: _nivelActividad,
                            isExpanded: true,
                            items: NivelActividad.values.map((nivel) {
                              return DropdownMenuItem(
                                value: nivel,
                                child: Text(
                                  _getNivelActividadTexto(nivel, loc),
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _nivelActividad = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Botón Calcular
                  SizedBox(
                    width: double.infinity,
                    height: isSmallScreen ? 50 : 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Crear persona actualizada con los nuevos datos
                          final personaActualizada = widget.personaActual
                              .copyWith(
                                edad: _edad,
                                sexo: _sexo,
                                nivelActividad: _nivelActividad,
                              );

                          // Navegar a la página de plan personalizado
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanPersonalizadoPage(
                                persona: personaActualizada,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            loc.calculateMyPlan,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 12),

                  // Texto informativo
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        loc.backToResults,
                        style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Obtiene el texto traducido para un nivel de actividad
  String _getNivelActividadTexto(NivelActividad nivel, AppLocalizations loc) {
    switch (nivel) {
      case NivelActividad.sedentario:
        return loc.sedentaryActivity;
      case NivelActividad.ligero:
        return loc.lightActivity;
      case NivelActividad.moderado:
        return loc.moderateActivity;
      case NivelActividad.activo:
        return loc.activeActivity;
      case NivelActividad.muyActivo:
        return loc.veryActiveActivity;
    }
  }
}
