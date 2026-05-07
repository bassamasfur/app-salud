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
  String get whatIsImcDesc => 'El Índice de Masa Corporal es una medida que relaciona tu peso y altura para determinar si tienes un peso saludable.';

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
  String get completeInfoToCalculateImc => 'Completa la información para calcular tu IMC';

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
  String get descUnderweight => 'Tu peso está por debajo del rango saludable. Es recomendable consultar con un profesional de la salud.';

  @override
  String get descNormal => '¡Felicidades! Tu peso está dentro del rango saludable. Mantén tus buenos hábitos.';

  @override
  String get descOverweight => 'Tu peso está ligeramente por encima del rango saludable. Considera hacer algunos ajustes en tu estilo de vida.';

  @override
  String get descObesity => 'Tu peso está significativamente por encima del rango saludable. Es importante buscar ayuda profesional.';

  @override
  String get descDefault => 'Consulta con un profesional de la salud para más información.';

  @override
  String get recommendationsUnderweight => 'Consulta con un nutricionista para un plan de alimentación adecuado|Incluye alimentos ricos en proteínas y grasas saludables|Considera hacer ejercicio de fuerza para ganar masa muscular|Evita el estrés excesivo que puede afectar tu apetito';

  @override
  String get recommendationsNormal => 'Mantén una dieta equilibrada rica en frutas y verduras|Realiza actividad física regular (al menos 150 min/semana)|Mantén un horario regular de comidas|Hidrátate adecuadamente (8 vasos de agua al día)';

  @override
  String get recommendationsOverweight => 'Reduce las porciones de comida gradualmente|Incrementa el consumo de fibra y proteínas magras|Realiza ejercicio cardiovascular regularmente|Limita alimentos procesados y bebidas azucaradas';

  @override
  String get recommendationsObesity => 'Consulta con un médico para un plan de pérdida de peso seguro|Considera trabajar con un nutricionista profesional|Inicia con ejercicio de baja intensidad y aumenta gradualmente|Busca apoyo emocional si es necesario';

  @override
  String get recommendationsDefault => 'Consulta con un profesional de la salud para más información.';

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

  @override
  String get completeYourProfile => 'Completa tu Perfil';

  @override
  String get profileDescription => 'Para calcular tu peso ideal y plan de calorías personalizado, necesitamos algunos datos adicionales';

  @override
  String get age => 'Edad';

  @override
  String get yourAgeInYears => 'Tu edad en años';

  @override
  String get years => 'años';

  @override
  String get sex => 'Sexo';

  @override
  String get male => 'Hombre';

  @override
  String get female => 'Mujer';

  @override
  String get physicalActivityLevel => 'Nivel de Actividad Física';

  @override
  String get calculateMyPlan => 'Calcular Mi Plan';

  @override
  String get backToResults => 'Volver a resultados';

  @override
  String get pleaseEnterAge => 'Por favor ingresa tu edad';

  @override
  String get ageRange => 'La edad debe estar entre 1 y 120 años';

  @override
  String get pleaseSelectSex => 'Por favor selecciona tu sexo';

  @override
  String get pleaseSelectActivity => 'Por favor selecciona tu nivel de actividad';

  @override
  String get yourPersonalizedPlan => 'Tu Plan Personalizado';

  @override
  String get planGenerated => '¡Plan Generado!';

  @override
  String get personalizedHealthPlan => 'Este es tu plan de salud personalizado';

  @override
  String get healthyWeightRange => 'Rango de Peso Saludable';

  @override
  String get minimum => 'Mínimo';

  @override
  String get ideal => 'Ideal';

  @override
  String get maximum => 'Máximo';

  @override
  String get yourNutritionalPlan => 'Tu Plan Nutricional';

  @override
  String get basalMetabolism => 'Metabolismo\nBasal';

  @override
  String get maintenanceCalories => 'Calorías de\nMantenimiento';

  @override
  String get recommendedGoal => 'META RECOMENDADA';

  @override
  String weeksToIdealWeight(Object weeks) {
    return 'Alcanzarás tu peso ideal en ~$weeks semanas';
  }

  @override
  String get otherCalorieOptions => 'Otras opciones de calorías:';

  @override
  String get maintainWeight => 'Mantener peso';

  @override
  String get moderateWeightLoss => 'Perder peso moderado';

  @override
  String get rapidWeightLoss => 'Perder peso rápido';

  @override
  String get gainWeight => 'Ganar peso';

  @override
  String get yourProfile => 'Tu Perfil';

  @override
  String get activityLevel => 'Nivel de Actividad';

  @override
  String get personalizedProfile => 'Perfil Personalizado';

  @override
  String get sedentaryActivity => 'Sedentario (poco o nada de ejercicio)';

  @override
  String get lightActivity => 'Ligero (ejercicio 1-3 días/semana)';

  @override
  String get moderateActivity => 'Moderado (ejercicio 3-5 días/semana)';

  @override
  String get activeActivity => 'Activo (ejercicio 6-7 días/semana)';

  @override
  String get veryActiveActivity => 'Muy Activo (ejercicio intenso diario)';

  @override
  String get personalizedHealthPlanTitle => 'Plan Personalizado de Salud';

  @override
  String get personalizedNutritionalPlan => 'Plan Nutricional Personalizado';

  @override
  String get profile => 'Perfil:';

  @override
  String get basalMetabolismTMB => 'Metabolismo Basal (TMB)';

  @override
  String get maintenanceCaloriesFull => 'Calorías Mantenimiento';

  @override
  String get weeklyChangeModerate => '(-0.5 kg/semana)';

  @override
  String get weeklyChangeRapid => '(-1 kg/semana)';

  @override
  String get weeklyChangeGain => '(+0.3 kg/semana)';

  @override
  String get calPerDay => 'cal/día';

  @override
  String get unlockFullPlan => 'Desbloquea Plan Completo';

  @override
  String get discoverIdealWeight => 'Descubre tu peso ideal y plan de calorías personalizado';

  @override
  String get featureMinMaxWeight => 'Peso mínimo, ideal y máximo saludable';

  @override
  String get featureDailyCalories => 'Meta de calorías diarias personalizada';

  @override
  String get featureTimeToGoal => 'Tiempo estimado para alcanzar tu meta';

  @override
  String get featureMultipleScenarios => 'Múltiples escenarios de calorías';

  @override
  String get featureOneTimePurchase => 'Compra única, sin suscripciones';

  @override
  String oneTimePayment(Object price) {
    return 'Pago único $price';
  }

  @override
  String get restorePurchase => 'Restaurar compra';

  @override
  String get purchaseError => 'No se pudo procesar la compra';

  @override
  String get historyTitle => 'Historial';

  @override
  String get viewHistory => 'Ver Historial';

  @override
  String get clearHistory => 'Limpiar Historial';

  @override
  String get noMeasurements => 'Sin Mediciones';

  @override
  String get noMeasurementsDesc => 'Aún no has guardado ninguna medición. Calcula tu IMC y guarda el resultado para hacer seguimiento de tu progreso.';

  @override
  String get addMeasurement => 'Agregar Medición';

  @override
  String totalMeasurements(Object count, Object limit) {
    return '$count de $limit mediciones';
  }

  @override
  String get limitReached => 'Has alcanzado el límite. Actualiza a Premium para guardar más.';

  @override
  String get getPremium => 'Obtener Premium';

  @override
  String get saveMeasurement => 'Guardar Medición';

  @override
  String get measurementSaved => 'Medición guardada exitosamente';

  @override
  String get errorSavingMeasurement => 'Error al guardar la medición';

  @override
  String get deleteConfirmTitle => '¿Eliminar medición?';

  @override
  String get deleteConfirmMessage => 'Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get measurementDeleted => 'Medición eliminada';

  @override
  String get clearHistoryTitle => '¿Limpiar historial?';

  @override
  String get clearHistoryMessage => 'Esto eliminará todas las mediciones guardadas. Esta acción no se puede deshacer.';

  @override
  String get clearAll => 'Eliminar Todo';

  @override
  String get historyCleared => 'Historial limpiado';

  @override
  String get measurementDetails => 'Detalles de la Medición';

  @override
  String get close => 'Cerrar';
}
