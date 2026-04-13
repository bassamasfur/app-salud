/// Sexo del usuario (necesario para calcular calorías)
enum Sexo { hombre, mujer }

/// Nivel de actividad física del usuario
enum NivelActividad {
  sedentario, // Poco o nada de ejercicio
  ligero, // Ejercicio ligero 1-3 días/semana
  moderado, // Ejercicio moderado 3-5 días/semana
  activo, // Ejercicio intenso 6-7 días/semana
  muyActivo, // Ejercicio muy intenso o trabajo físico
}

/// Extensión para obtener descripciones legibles
extension NivelActividadExtension on NivelActividad {
  String get descripcion {
    switch (this) {
      case NivelActividad.sedentario:
        return 'Sedentario (poco o nada de ejercicio)';
      case NivelActividad.ligero:
        return 'Ligero (ejercicio 1-3 días/semana)';
      case NivelActividad.moderado:
        return 'Moderado (ejercicio 3-5 días/semana)';
      case NivelActividad.activo:
        return 'Activo (ejercicio 6-7 días/semana)';
      case NivelActividad.muyActivo:
        return 'Muy Activo (ejercicio intenso diario)';
    }
  }

  /// Multiplicador para calcular TDEE a partir de TMB
  double get multiplicador {
    switch (this) {
      case NivelActividad.sedentario:
        return 1.2;
      case NivelActividad.ligero:
        return 1.375;
      case NivelActividad.moderado:
        return 1.55;
      case NivelActividad.activo:
        return 1.725;
      case NivelActividad.muyActivo:
        return 1.9;
    }
  }
}
