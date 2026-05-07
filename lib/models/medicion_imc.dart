import 'enums.dart';

/// Modelo que representa una medición de IMC guardada en el historial
class MedicionIMC {
  final DateTime fecha;
  final String nombre;
  final double peso;
  final double altura;
  final double imc;
  final String categoria;
  final int? edad;
  final Sexo? sexo;
  final NivelActividad? nivelActividad;

  MedicionIMC({
    required this.fecha,
    required this.nombre,
    required this.peso,
    required this.altura,
    required this.imc,
    required this.categoria,
    this.edad,
    this.sexo,
    this.nivelActividad,
  });

  /// Convierte la medición a un mapa JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha.toIso8601String(),
      'nombre': nombre,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'categoria': categoria,
      'edad': edad,
      'sexo': sexo?.toString().split('.').last,
      'nivelActividad': nivelActividad?.toString().split('.').last,
    };
  }

  /// Crea una medición desde un mapa JSON
  factory MedicionIMC.fromJson(Map<String, dynamic> json) {
    return MedicionIMC(
      fecha: DateTime.parse(json['fecha'] as String),
      nombre: json['nombre'] as String,
      peso: (json['peso'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      imc: (json['imc'] as num).toDouble(),
      categoria: json['categoria'] as String,
      edad: json['edad'] as int?,
      sexo: json['sexo'] != null
          ? Sexo.values.firstWhere(
              (e) => e.toString().split('.').last == json['sexo'],
            )
          : null,
      nivelActividad: json['nivelActividad'] != null
          ? NivelActividad.values.firstWhere(
              (e) => e.toString().split('.').last == json['nivelActividad'],
            )
          : null,
    );
  }

  /// Copia la medición con algunos campos modificados
  MedicionIMC copyWith({
    DateTime? fecha,
    String? nombre,
    double? peso,
    double? altura,
    double? imc,
    String? categoria,
    int? edad,
    Sexo? sexo,
    NivelActividad? nivelActividad,
  }) {
    return MedicionIMC(
      fecha: fecha ?? this.fecha,
      nombre: nombre ?? this.nombre,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      imc: imc ?? this.imc,
      categoria: categoria ?? this.categoria,
      edad: edad ?? this.edad,
      sexo: sexo ?? this.sexo,
      nivelActividad: nivelActividad ?? this.nivelActividad,
    );
  }
}
