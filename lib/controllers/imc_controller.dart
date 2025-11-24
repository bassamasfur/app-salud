import 'package:flutter/material.dart';
import '../models/persona.dart';

/// Controlador que maneja la lógica de negocio para el cálculo del IMC
/// Implementa el patrón MVC separando la lógica de la vista
class IMCController extends ChangeNotifier {
  // Estado del controlador
  Persona? _persona;
  bool _isLoading = false;
  String? _errorMessage;

  // Controllers para los campos del formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  // Getters para acceder al estado
  Persona? get persona => _persona;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPersona => _persona != null;

  /// Limpia todos los datos y controladores
  void limpiarDatos() {
    _persona = null;
    _errorMessage = null;
    _isLoading = false;
    nombreController.clear();
    pesoController.clear();
    alturaController.clear();
    notifyListeners();
  }

  /// Valida los datos del formulario
  String? validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    if (valor.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validarPeso(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El peso es requerido';
    }

    final peso = double.tryParse(valor.trim());
    if (peso == null) {
      return 'Ingrese un peso válido';
    }

    if (peso <= 0) {
      return 'El peso debe ser mayor a 0';
    }

    if (peso > 500) {
      return 'Ingrese un peso realista (máximo 500kg)';
    }

    return null;
  }

  String? validarAltura(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'La altura es requerida';
    }

    final altura = double.tryParse(valor.trim());
    if (altura == null) {
      return 'Ingrese una altura válida';
    }

    if (altura <= 0) {
      return 'La altura debe ser mayor a 0';
    }

    if (altura > 3.0) {
      return 'Ingrese una altura realista (máximo 3.0m)';
    }

    if (altura < 0.5) {
      return 'Ingrese una altura realista (mínimo 0.5m)';
    }

    return null;
  }

  /// Calcula el IMC con los datos del formulario
  Future<bool> calcularIMC() async {
    _setLoading(true);
    _clearError();

    try {
      // Validar campos
      final nombreError = validarNombre(nombreController.text);
      final pesoError = validarPeso(pesoController.text);
      final alturaError = validarAltura(alturaController.text);

      if (nombreError != null || pesoError != null || alturaError != null) {
        _setError('Por favor, corrija los errores en el formulario');
        return false;
      }

      // Crear persona con los datos validados
      final nombre = nombreController.text.trim();
      final peso = double.parse(pesoController.text.trim());
      final altura = double.parse(alturaController.text.trim());

      // Simular un pequeño delay para mostrar el loading
      await Future.delayed(const Duration(milliseconds: 500));

      _persona = Persona(nombre: nombre, peso: peso, altura: altura);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al calcular el IMC: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza los datos de una persona existente
  Future<bool> actualizarPersona({
    String? nuevoNombre,
    double? nuevoPeso,
    double? nuevaAltura,
  }) async {
    if (_persona == null) return false;

    _setLoading(true);
    _clearError();

    try {
      if (nuevoNombre != null) {
        _persona!.nombre = nuevoNombre;
      }
      if (nuevoPeso != null) {
        _persona!.peso = nuevoPeso;
      }
      if (nuevaAltura != null) {
        _persona!.altura = nuevaAltura;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al actualizar los datos: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene el IMC formateado como string
  String get imcFormateado {
    if (_persona == null) return '0.0';
    return _persona!.calcularIMC().toStringAsFixed(1);
  }

  /// Obtiene la categoría del IMC
  String get categoriaIMC {
    if (_persona == null) return '';
    return _persona!.obtenerCategoriaIMC();
  }

  /// Obtiene las recomendaciones basadas en el IMC
  String get recomendaciones {
    if (_persona == null) return '';
    return _persona!.obtenerRecomendaciones();
  }

  /// Obtiene el color asociado a la categoría
  Color get colorCategoria {
    if (_persona == null) return Colors.grey;

    final colorString = _persona!.obtenerColorCategoria();
    switch (colorString) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Guarda los datos en el formulario para edición
  void cargarDatosEnFormulario() {
    if (_persona != null) {
      nombreController.text = _persona!.nombre;
      pesoController.text = _persona!.peso.toString();
      alturaController.text = _persona!.altura.toString();
    }
  }

  // Métodos privados para manejo del estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nombreController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }
}
