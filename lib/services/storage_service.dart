import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicion_imc.dart';
import '../models/persona.dart';

/// Servicio para gestionar el almacenamiento local de mediciones de IMC
/// Usa SharedPreferences para persistir datos entre sesiones
class StorageService {
  static const String _keyMediciones = 'historial_mediciones';
  static const int _limiteGratis = 10; // 10 mediciones para usuarios gratuitos
  static const int _limitePremium = 50; // 50 mediciones para usuarios premium

  /// Guarda una nueva medición en el historial
  /// Respeta el límite según el estado premium del usuario
  static Future<bool> guardarMedicion(Persona persona, bool isPremium) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Crear la medición desde los datos de la persona
      final medicion = MedicionIMC(
        fecha: DateTime.now(),
        nombre: persona.nombre,
        peso: persona.peso,
        altura: persona.altura,
        imc: persona.calcularIMC(),
        categoria: persona.obtenerCategoriaIMC(),
        edad: persona.edad,
        sexo: persona.sexo,
        nivelActividad: persona.nivelActividad,
      );

      // Obtener mediciones existentes
      List<MedicionIMC> mediciones = await obtenerMediciones();

      // Agregar la nueva medición al inicio (más reciente primero)
      mediciones.insert(0, medicion);

      // Aplicar límite según el tipo de usuario
      final limite = isPremium ? _limitePremium : _limiteGratis;
      if (mediciones.length > limite) {
        mediciones = mediciones.sublist(0, limite);
      }

      // Convertir a JSON y guardar
      final jsonList = mediciones.map((m) => m.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_keyMediciones, jsonString);

      if (kDebugMode) {
        print('✅ Medición guardada. Total: ${mediciones.length}/$limite');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error guardando medición: $e');
      }
      return false;
    }
  }

  /// Obtiene todas las mediciones guardadas
  static Future<List<MedicionIMC>> obtenerMediciones() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyMediciones);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final mediciones = jsonList
          .map((json) => MedicionIMC.fromJson(json as Map<String, dynamic>))
          .toList();

      if (kDebugMode) {
        print('📊 Mediciones cargadas: ${mediciones.length}');
      }

      return mediciones;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando mediciones: $e');
      }
      return [];
    }
  }

  /// Elimina una medición específica del historial
  static Future<bool> eliminarMedicion(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<MedicionIMC> mediciones = await obtenerMediciones();

      if (index < 0 || index >= mediciones.length) {
        return false;
      }

      mediciones.removeAt(index);

      // Guardar la lista actualizada
      final jsonList = mediciones.map((m) => m.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_keyMediciones, jsonString);

      if (kDebugMode) {
        print('🗑️ Medición eliminada. Total restante: ${mediciones.length}');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error eliminando medición: $e');
      }
      return false;
    }
  }

  /// Limpia todo el historial de mediciones
  static Future<bool> limpiarHistorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyMediciones);

      if (kDebugMode) {
        print('🗑️ Historial limpiado completamente');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error limpiando historial: $e');
      }
      return false;
    }
  }

  /// Obtiene el número de mediciones guardadas
  static Future<int> contarMediciones() async {
    final mediciones = await obtenerMediciones();
    return mediciones.length;
  }

  /// Verifica si el usuario puede guardar más mediciones
  static Future<bool> puedeGuardarMas(bool isPremium) async {
    final count = await contarMediciones();
    final limite = isPremium ? _limitePremium : _limiteGratis;
    return count < limite;
  }

  /// Obtiene el límite de mediciones según el tipo de usuario
  static int obtenerLimite(bool isPremium) {
    return isPremium ? _limitePremium : _limiteGratis;
  }
}
