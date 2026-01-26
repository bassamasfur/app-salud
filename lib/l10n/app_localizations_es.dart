// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora IMC';

  @override
  String get subtitle => 'Índice de Masa Corporal';

  @override
  String get whatIsImcTitle => '¿Qué es el IMC?';

  @override
  String get whatIsImcDesc =>
      'El Índice de Masa Corporal es una medida que relaciona tu peso y altura para determinar si tienes un peso saludable.';

  @override
  String get imcRanges => 'Rangos de IMC:';

  @override
  String get underweight => 'Bajo peso';

  @override
  String get normal => 'Normal';

  @override
  String get overweight => 'Sobrepeso';

  @override
  String get obesity => 'Obesidad';

  @override
  String get calculateImc => 'Calcular mi IMC';

  @override
  String get developedBy => 'Desarrollado por Bassam Asfur';

  @override
  String get personalData => 'Datos Personales';

  @override
  String get enterYourData => 'Ingresa tus datos';

  @override
  String get completeInfoToCalculateImc =>
      'Completa la información para calcular tu IMC';

  @override
  String get enterHeightHint => 'Ingresa tu altura en metros (ej: 1.75)';

  @override
  String get name => 'Nombre';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get weight => 'Peso (kg)';

  @override
  String get weightHint => 'Ej: 70.5';

  @override
  String get height => 'Altura (m)';

  @override
  String get heightHint => 'Ej: 1.75';

  @override
  String get resultTitle => 'Resultado IMC';

  @override
  String get newCalculation => 'Nuevo cálculo';

  @override
  String get interpretation => 'INTERPRETACIÓN';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String greeting(Object name) {
    return '¡Hola, $name!';
  }

  @override
  String get evaluationResults => 'Resultados de tu evaluación';

  @override
  String get yourImcIs => 'Tu IMC es:';

  @override
  String weightWithUnit(Object weight) {
    return 'Peso: $weight kg';
  }

  @override
  String heightWithUnit(Object height) {
    return 'Altura: $height m';
  }

  @override
  String get descUnderweight =>
      'Tu peso está por debajo del rango saludable. Es recomendable consultar con un profesional de la salud.';

  @override
  String get descNormal =>
      '¡Felicidades! Tu peso está dentro del rango saludable. Mantén tus buenos hábitos.';

  @override
  String get descOverweight =>
      'Tu peso está ligeramente por encima del rango saludable. Considera hacer algunos ajustes en tu estilo de vida.';

  @override
  String get descObesity =>
      'Tu peso está significativamente por encima del rango saludable. Es importante buscar ayuda profesional.';

  @override
  String get descDefault =>
      'Consulta con un profesional de la salud para más información.';

  @override
  String get recommendationsUnderweight =>
      'Consulta con un nutricionista para un plan de alimentación adecuado|Incluye alimentos ricos en proteínas y grasas saludables|Considera hacer ejercicio de fuerza para ganar masa muscular|Evita el estrés excesivo que puede afectar tu apetito';

  @override
  String get recommendationsNormal =>
      'Mantén una dieta equilibrada rica en frutas y verduras|Realiza actividad física regular (al menos 150 min/semana)|Mantén un horario regular de comidas|Hidrátate adecuadamente (8 vasos de agua al día)';

  @override
  String get recommendationsOverweight =>
      'Reduce las porciones de comida gradualmente|Incrementa el consumo de fibra y proteínas magras|Realiza ejercicio cardiovascular regularmente|Limita alimentos procesados y bebidas azucaradas';

  @override
  String get recommendationsObesity =>
      'Consulta con un médico para un plan de pérdida de peso seguro|Considera trabajar con un nutricionista profesional|Inicia con ejercicio de baja intensidad y aumenta gradualmente|Busca apoyo emocional si es necesario';

  @override
  String get recommendationsDefault =>
      'Consulta con un profesional de la salud para más información.';

  @override
  String get calculateAnotherImc => 'Calcular otro IMC';

  @override
  String get viewReport => 'Ver Informe';

  @override
  String get viewReportCancel => 'Cancelar';

  @override
  String get viewReportSend => 'Enviar Informe';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get pdfTitle => 'INFORME DE ÍNDICE DE MASA CORPORAL (IMC)';

  @override
  String get pdfPatientInfo => 'INFORMACIÓN DEL PACIENTE';

  @override
  String get pdfResult => 'RESULTADO DEL IMC';

  @override
  String get pdfReferenceTable => 'Tabla de Referencia IMC';

  @override
  String pdfDate(Object date) {
    return 'Fecha: $date';
  }

  @override
  String get category => 'Categoría';

  @override
  String get generatingPreview => 'Generando vista previa...';
}
