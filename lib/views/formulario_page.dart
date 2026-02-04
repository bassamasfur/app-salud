import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../controllers/imc_controller.dart';

/// Página del formulario para capturar los datos del usuario
/// Permite ingresar nombre, peso y altura con validaciones
class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _imcController = IMCController();

  @override
  void dispose() {
    _imcController.dispose();
    super.dispose();
  }

  /// Maneja el envío del formulario
  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final success = await _imcController.calcularIMC();

      if (success && mounted) {
        // Navegar a la página de resultados
        Navigator.pushNamed(context, '/resultado', arguments: _imcController);
      } else if (_imcController.errorMessage != null && mounted) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_imcController.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de pantalla para responsividad
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Sistema de 3 niveles para mejor compatibilidad
    final isTinyScreen = screenHeight < 600; // < 5.5" (iPhone SE, Galaxy S5)
    final isSmallScreen =
        screenHeight >= 600 && screenHeight < 680; // 5.5"-6" (S8, Pixel 4a)
    // Para pantallas >= 680px usamos los valores por defecto

    final isWideScreen = screenWidth > 400;

    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.personalData,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isTinyScreen ? 16 : (isSmallScreen ? 18 : 20),
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
              // Contenido que se adapta al espacio disponible
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 24.0 : 20.0,
                    vertical: isTinyScreen
                        ? 8.0
                        : (isSmallScreen ? 12.0 : 20.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: isTinyScreen ? 4 : (isSmallScreen ? 6 : 16),
                        ),

                        // Título e instrucciones - responsive
                        Text(
                          loc.enterYourData,
                          style: TextStyle(
                            fontSize: isTinyScreen
                                ? 20
                                : (isSmallScreen ? 22 : 28),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: isTinyScreen ? 4 : (isSmallScreen ? 6 : 10),
                        ),

                        Text(
                          loc.completeInfoToCalculateImc,
                          style: TextStyle(
                            fontSize: isTinyScreen
                                ? 12
                                : (isSmallScreen ? 13 : 16),
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: isTinyScreen ? 10 : (isSmallScreen ? 14 : 24),
                        ),

                        // Card con el formulario - responsive
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              isTinyScreen
                                  ? 10.0
                                  : (isSmallScreen ? 12.0 : 18.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Campo Nombre
                                _buildCampoNombre(
                                  isTinyScreen,
                                  isSmallScreen,
                                  loc,
                                ),

                                SizedBox(
                                  height: isTinyScreen
                                      ? 10
                                      : (isSmallScreen ? 12 : 18),
                                ),

                                // Campo Peso
                                _buildCampoPeso(
                                  isTinyScreen,
                                  isSmallScreen,
                                  loc,
                                ),

                                SizedBox(
                                  height: isTinyScreen
                                      ? 10
                                      : (isSmallScreen ? 12 : 18),
                                ),

                                // Campo Altura
                                _buildCampoAltura(
                                  isTinyScreen,
                                  isSmallScreen,
                                  loc,
                                ),

                                SizedBox(
                                  height: isTinyScreen
                                      ? 10
                                      : (isSmallScreen ? 14 : 20),
                                ),

                                // Información adicional - responsive
                                Container(
                                  padding: EdgeInsets.all(
                                    isTinyScreen ? 6 : (isSmallScreen ? 8 : 14),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue[600],
                                        size: isTinyScreen
                                            ? 15
                                            : (isSmallScreen ? 16 : 20),
                                      ),
                                      SizedBox(
                                        width: isTinyScreen
                                            ? 5
                                            : (isSmallScreen ? 6 : 10),
                                      ),
                                      Expanded(
                                        child: Text(
                                          loc.enterHeightHint,
                                          style: TextStyle(
                                            fontSize: isTinyScreen
                                                ? 10.5
                                                : (isSmallScreen ? 11.5 : 14),
                                            color: Colors.black87,
                                            height: 1.3,
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
                      ],
                    ),
                  ),
                ),
              ),

              // Sección inferior fija con botón
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 24.0 : 20.0,
                  vertical: isTinyScreen ? 8.0 : (isSmallScreen ? 12.0 : 16.0),
                ),
                child: AnimatedBuilder(
                  animation: _imcController,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: isTinyScreen ? 42 : (isSmallScreen ? 45 : 50),
                      child: ElevatedButton(
                        onPressed: _imcController.isLoading
                            ? null
                            : _enviarFormulario,
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
                        child: _imcController.isLoading
                            ? SizedBox(
                                width: isTinyScreen
                                    ? 18
                                    : (isSmallScreen ? 20 : 24),
                                height: isTinyScreen
                                    ? 18
                                    : (isSmallScreen ? 20 : 24),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2E86AB),
                                  ),
                                ),
                              )
                            : Text(
                                loc.calculateImc,
                                style: TextStyle(
                                  fontSize: isTinyScreen
                                      ? 14
                                      : (isSmallScreen ? 15 : 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para el campo de nombre - responsive
  Widget _buildCampoNombre(
    bool isTinyScreen,
    bool isSmallScreen,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.name,
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E86AB),
          ),
        ),
        SizedBox(height: isTinyScreen ? 3 : (isSmallScreen ? 4 : 6)),
        TextFormField(
          controller: _imcController.nombreController,
          decoration: InputDecoration(
            hintText: loc.enterYourName,
            hintStyle: TextStyle(
              fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: const Color(0xFF2E86AB),
              size: isTinyScreen ? 18 : (isSmallScreen ? 20 : 24),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
              vertical: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
            ),
          ),
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
          ),
          textCapitalization: TextCapitalization.words,
          validator: _imcController.validarNombre,
        ),
      ],
    );
  }

  /// Widget para el campo de peso - responsive
  Widget _buildCampoPeso(
    bool isTinyScreen,
    bool isSmallScreen,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.weight,
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E86AB),
          ),
        ),
        SizedBox(height: isTinyScreen ? 3 : (isSmallScreen ? 4 : 6)),
        TextFormField(
          controller: _imcController.pesoController,
          decoration: InputDecoration(
            hintText: loc.weightHint,
            hintStyle: TextStyle(
              fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            ),
            prefixIcon: Icon(
              Icons.monitor_weight,
              color: const Color(0xFF2E86AB),
              size: isTinyScreen ? 18 : (isSmallScreen ? 20 : 24),
            ),
            suffixText: 'kg',
            suffixStyle: TextStyle(
              fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
              vertical: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
            ),
          ),
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          validator: _imcController.validarPeso,
        ),
      ],
    );
  }

  /// Widget para el campo de altura - responsive
  Widget _buildCampoAltura(
    bool isTinyScreen,
    bool isSmallScreen,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.height,
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E86AB),
          ),
        ),
        SizedBox(height: isTinyScreen ? 3 : (isSmallScreen ? 4 : 6)),
        TextFormField(
          controller: _imcController.alturaController,
          decoration: InputDecoration(
            hintText: loc.heightHint,
            hintStyle: TextStyle(
              fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
            ),
            prefixIcon: Icon(
              Icons.height,
              color: const Color(0xFF2E86AB),
              size: isTinyScreen ? 18 : (isSmallScreen ? 20 : 24),
            ),
            suffixText: 'm',
            suffixStyle: TextStyle(
              fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
              vertical: isTinyScreen ? 8 : (isSmallScreen ? 10 : 14),
            ),
          ),
          style: TextStyle(
            fontSize: isTinyScreen ? 13 : (isSmallScreen ? 14 : 16),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          validator: _imcController.validarAltura,
        ),
      ],
    );
  }
}
