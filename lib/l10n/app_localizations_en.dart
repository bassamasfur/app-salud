// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BMI Calculator';

  @override
  String get subtitle => 'Body Mass Index';

  @override
  String get whatIsImcTitle => 'What is BMI?';

  @override
  String get whatIsImcDesc =>
      'Body Mass Index is a measure that relates your weight and height to determine if you have a healthy weight.';

  @override
  String get imcRanges => 'BMI Ranges:';

  @override
  String get underweight => 'Underweight';

  @override
  String get normal => 'Normal';

  @override
  String get overweight => 'Overweight';

  @override
  String get obesity => 'Obesity';

  @override
  String get calculateImc => 'Calculate my BMI';

  @override
  String get developedBy => 'Developed by Bassam Asfur';

  @override
  String get personalData => 'Personal Data';

  @override
  String get enterYourData => 'Enter your data';

  @override
  String get completeInfoToCalculateImc =>
      'Complete the information to calculate your BMI';

  @override
  String get enterHeightHint => 'Enter your height in meters (e.g., 1.75)';

  @override
  String get name => 'Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get weight => 'Weight (kg)';

  @override
  String get weightHint => 'E.g.: 70.5';

  @override
  String get height => 'Height (m)';

  @override
  String get heightHint => 'E.g.: 1.75';

  @override
  String get resultTitle => 'BMI Result';

  @override
  String get newCalculation => 'New calculation';

  @override
  String get interpretation => 'INTERPRETATION';

  @override
  String get recommendations => 'Recommendations';

  @override
  String greeting(Object name) {
    return 'Hello, $name!';
  }

  @override
  String get evaluationResults => 'Your evaluation results';

  @override
  String get yourImcIs => 'Your BMI is:';

  @override
  String weightWithUnit(Object weight) {
    return 'Weight: $weight kg';
  }

  @override
  String heightWithUnit(Object height) {
    return 'Height: $height m';
  }

  @override
  String get descUnderweight =>
      'Your weight is below the healthy range. It is recommended to consult a health professional.';

  @override
  String get descNormal =>
      'Congratulations! Your weight is within the healthy range. Keep up your good habits.';

  @override
  String get descOverweight =>
      'Your weight is slightly above the healthy range. Consider making some lifestyle adjustments.';

  @override
  String get descObesity =>
      'Your weight is significantly above the healthy range. It is important to seek professional help.';

  @override
  String get descDefault =>
      'Consult a health professional for more information.';

  @override
  String get recommendationsUnderweight =>
      'Consult a nutritionist for an appropriate meal plan|Include foods rich in protein and healthy fats|Consider strength training to gain muscle mass|Avoid excessive stress that can affect your appetite';

  @override
  String get recommendationsNormal =>
      'Maintain a balanced diet rich in fruits and vegetables|Exercise regularly (at least 150 min/week)|Keep a regular meal schedule|Stay hydrated (8 glasses of water a day)';

  @override
  String get recommendationsOverweight =>
      'Gradually reduce food portions|Increase fiber and lean protein intake|Do regular cardiovascular exercise|Limit processed foods and sugary drinks';

  @override
  String get recommendationsObesity =>
      'Consult a doctor for a safe weight loss plan|Consider working with a professional nutritionist|Start with low-intensity exercise and increase gradually|Seek emotional support if necessary';

  @override
  String get recommendationsDefault =>
      'Consult a health professional for more information.';

  @override
  String get calculateAnotherImc => 'Calculate another BMI';

  @override
  String get viewReport => 'View Report';

  @override
  String get viewReportCancel => 'Cancel';

  @override
  String get viewReportSend => 'Send Report';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get pdfTitle => 'BODY MASS INDEX (BMI) REPORT';

  @override
  String get pdfPatientInfo => 'PATIENT INFORMATION';

  @override
  String get pdfResult => 'BMI RESULT';

  @override
  String get pdfReferenceTable => 'BMI Reference Table';

  @override
  String pdfDate(Object date) {
    return 'Date: $date';
  }

  @override
  String get category => 'Category';

  @override
  String get generatingPreview => 'Generating preview...';
}
