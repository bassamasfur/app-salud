/// Modelo que representa una persona con sus datos para calcular el IMC
class Persona {
  // Propiedades privadas
  double _peso;
  double _altura;
  String _nombre;

  // Constructor
  Persona({
    required String nombre,
    required double peso,
    required double altura,
  }) : _nombre = nombre,
       _peso = peso,
       _altura = altura {
    // Validaciones
    if (_peso <= 0) {
      throw ArgumentError('El peso debe ser mayor a 0');
    }
    if (_altura <= 0) {
      throw ArgumentError('La altura debe ser mayor a 0');
    }
  }

  // Getters
  String get nombre => _nombre;
  double get peso => _peso;
  double get altura => _altura;

  // Setters con validación
  set nombre(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }
    _nombre = value.trim();
  }

  set peso(double value) {
    if (value <= 0) {
      throw ArgumentError('El peso debe ser mayor a 0');
    }
    _peso = value;
  }

  set altura(double value) {
    if (value <= 0) {
      throw ArgumentError('La altura debe ser mayor a 0');
    }
    _altura = value;
  }

  /// Calcula el Índice de Masa Corporal (IMC)
  /// Fórmula: IMC = peso (kg) / altura (m)²
  double calcularIMC() {
    return _peso / (_altura * _altura);
  }

  /// Obtiene la categoría del IMC según los estándares de la OMS
  String obtenerCategoriaIMC() {
    double imc = calcularIMC();

    if (imc < 18.5) {
      return 'bajo peso';
    } else if (imc >= 18.5 && imc < 25) {
      return 'normal';
    } else if (imc >= 25 && imc < 30) {
      return 'sobrepeso';
    } else {
      return 'obesidad';
    }
  }

  /// Obtiene el color asociado a la categoría del IMC
  String obtenerColorCategoria() {
    double imc = calcularIMC();

    if (imc < 18.5) {
      return 'blue'; // Bajo peso
    } else if (imc >= 18.5 && imc < 25) {
      return 'green'; // Peso normal
    } else if (imc >= 25 && imc < 30) {
      return 'orange'; // Sobrepeso
    } else {
      return 'red'; // Obesidad
    }
  }

  /// Obtiene recomendaciones basadas en el IMC
  String obtenerRecomendaciones() {
    double imc = calcularIMC();

    if (imc < 18.5) {
      return 'Se recomienda consultar con un nutricionista para aumentar de peso de manera saludable.';
    } else if (imc >= 18.5 && imc < 25) {
      return '¡Excelente! Mantén tu peso actual con una dieta balanceada y ejercicio regular.';
    } else if (imc >= 25 && imc < 30) {
      return 'Se recomienda reducir el peso mediante dieta equilibrada y ejercicio cardiovascular.';
    } else {
      return 'Es importante consultar con un médico para desarrollar un plan de pérdida de peso seguro.';
    }
  }

  @override
  String toString() {
    return 'Persona(nombre: $_nombre, peso: ${_peso}kg, altura: ${_altura}m, IMC: ${calcularIMC().toStringAsFixed(2)})';
  }

  /// Convierte la persona a un Map para serialización
  Map<String, dynamic> toJson() {
    return {
      'nombre': _nombre,
      'peso': _peso,
      'altura': _altura,
      'imc': calcularIMC(),
      'categoria': obtenerCategoriaIMC(),
    };
  }

  /// Crea una persona desde un Map
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      nombre: json['nombre'],
      peso: json['peso'].toDouble(),
      altura: json['altura'].toDouble(),
    );
  }
}
