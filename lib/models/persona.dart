import 'enums.dart';

/// Modelo que representa una persona con sus datos para calcular el IMC
class Persona {
  // Propiedades privadas básicas
  double _peso;
  double _altura;
  String _nombre;

  // Propiedades opcionales para features premium
  int? _edad;
  Sexo? _sexo;
  NivelActividad? _nivelActividad;

  // Constructor
  Persona({
    required String nombre,
    required double peso,
    required double altura,
    int? edad,
    Sexo? sexo,
    NivelActividad? nivelActividad,
  }) : _nombre = nombre,
       _peso = peso,
       _altura = altura,
       _edad = edad,
       _sexo = sexo,
       _nivelActividad = nivelActividad {
    // Validaciones
    if (_peso <= 0) {
      throw ArgumentError('El peso debe ser mayor a 0');
    }
    if (_altura <= 0) {
      throw ArgumentError('La altura debe ser mayor a 0');
    }
    if (_edad != null && _edad! <= 0) {
      throw ArgumentError('La edad debe ser mayor a 0');
    }
  }

  // Getters
  String get nombre => _nombre;
  double get peso => _peso;
  double get altura => _altura;
  int? get edad => _edad;
  Sexo? get sexo => _sexo;
  NivelActividad? get nivelActividad => _nivelActividad;

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

  set edad(int? value) {
    if (value != null && value <= 0) {
      throw ArgumentError('La edad debe ser mayor a 0');
    }
    _edad = value;
  }

  set sexo(Sexo? value) {
    _sexo = value;
  }

  set nivelActividad(NivelActividad? value) {
    _nivelActividad = value;
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

  /// PREMIUM: Calcula el peso ideal y rango saludable
  /// Retorna un Map con: pesoMinimo, pesoIdeal, pesoMaximo, diferencia, mensaje
  Map<String, dynamic> calcularPesoIdeal() {
    final alturaMetros = _altura;
    final alturaSquared = alturaMetros * alturaMetros;

    final pesoMinimo = 18.5 * alturaSquared;
    final pesoIdeal = 22.0 * alturaSquared;
    final pesoMaximo = 24.9 * alturaSquared;

    final pesoActual = _peso;
    final diferencia = pesoActual - pesoIdeal;

    String mensaje;
    if (pesoActual < pesoMinimo) {
      mensaje =
          'Estás ${(pesoMinimo - pesoActual).abs().toStringAsFixed(1)} kg por debajo del peso mínimo saludable';
    } else if (pesoActual > pesoMaximo) {
      mensaje =
          'Estás ${(pesoActual - pesoMaximo).toStringAsFixed(1)} kg por encima del peso máximo saludable';
    } else if (pesoActual < pesoIdeal) {
      mensaje =
          'Estás ${(pesoIdeal - pesoActual).toStringAsFixed(1)} kg por debajo de tu peso ideal';
    } else if (pesoActual > pesoIdeal) {
      mensaje =
          'Estás ${(pesoActual - pesoIdeal).toStringAsFixed(1)} kg por encima de tu peso ideal';
    } else {
      mensaje = '¡Estás en tu peso ideal!';
    }

    return {
      'pesoMinimo': pesoMinimo,
      'pesoIdeal': pesoIdeal,
      'pesoMaximo': pesoMaximo,
      'diferencia': diferencia,
      'mensaje': mensaje,
    };
  }

  /// PREMIUM: Calcula la Tasa Metabólica Basal (TMB)
  /// Usa la fórmula Mifflin-St Jeor (más precisa que Harris-Benedict)
  /// Retorna null si edad o sexo no están definidos
  double? calcularTMB() {
    if (_edad == null || _sexo == null) return null;

    // Altura en cm para esta fórmula
    final alturaCm = _altura * 100;

    if (_sexo == Sexo.hombre) {
      return (10 * _peso) + (6.25 * alturaCm) - (5 * _edad!) + 5;
    } else {
      return (10 * _peso) + (6.25 * alturaCm) - (5 * _edad!) - 161;
    }
  }

  /// PREMIUM: Calcula el Total Daily Energy Expenditure (TDEE)
  /// Es decir, las calorías totales que quemas al día
  /// Retorna null si no se puede calcular TMB o nivelActividad no está definido
  double? calcularTDEE() {
    final tmb = calcularTMB();
    if (tmb == null || _nivelActividad == null) return null;

    return tmb * _nivelActividad!.multiplicador;
  }

  /// PREMIUM: Calcula metas de calorías personalizadas
  /// Retorna un Map con todas las opciones de calorías y recomendación
  /// Retorna null si no se pueden calcular las calorías (faltan datos)
  Map<String, dynamic>? calcularMetasCalorias() {
    final tdee = calcularTDEE();
    final pesoIdealData = calcularPesoIdeal();

    if (tdee == null) return null;

    final pesoIdeal = pesoIdealData['pesoIdeal'] as double;
    final diferenciaPeso = _peso - pesoIdeal;

    // Calorías para diferentes objetivos
    final mantenimiento = tdee;
    final perderModerado = tdee - 500; // -0.5kg/semana
    final perderRapido = tdee - 1000; // -1kg/semana (mínimo 1200 cal)
    final ganarPeso = tdee + 300; // +0.3kg/semana

    // Calcular meta recomendada según diferencia con peso ideal
    double metaRecomendada;
    String recomendacion;
    int semanasEstimadas = 0;

    if (diferenciaPeso > 2) {
      // Necesita perder peso
      metaRecomendada = perderModerado;
      recomendacion = 'Perder peso moderado';
      semanasEstimadas = (diferenciaPeso / 0.5).ceil();
    } else if (diferenciaPeso < -2) {
      // Necesita ganar peso
      metaRecomendada = ganarPeso;
      recomendacion = 'Ganar peso saludable';
      semanasEstimadas = (diferenciaPeso.abs() / 0.3).ceil();
    } else {
      // Está cerca del peso ideal
      metaRecomendada = mantenimiento;
      recomendacion = 'Mantener peso actual';
      semanasEstimadas = 0;
    }

    return {
      'tmb': calcularTMB()!.round(),
      'tdee': tdee.round(),
      'mantenimiento': mantenimiento.round(),
      'perderModerado': perderModerado.round(),
      'perderRapido': (perderRapido < 1200 ? 1200 : perderRapido).round(),
      'ganarPeso': ganarPeso.round(),
      'metaRecomendada': metaRecomendada.round(),
      'recomendacion': recomendacion,
      'semanasEstimadas': semanasEstimadas,
      'pesoIdeal': pesoIdeal,
      'diferenciaPeso': diferenciaPeso,
    };
  }

  /// Crea una copia de la persona con campos actualizados
  Persona copyWith({
    String? nombre,
    double? peso,
    double? altura,
    int? edad,
    Sexo? sexo,
    NivelActividad? nivelActividad,
  }) {
    return Persona(
      nombre: nombre ?? _nombre,
      peso: peso ?? _peso,
      altura: altura ?? _altura,
      edad: edad ?? _edad,
      sexo: sexo ?? _sexo,
      nivelActividad: nivelActividad ?? _nivelActividad,
    );
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
