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
  String get whatIsImcDesc => 'Body Mass Index is a measure that relates your weight and height to determine if you have a healthy weight.';

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
  String get completeInfoToCalculateImc => 'Complete the information to calculate your BMI';

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
  String get descUnderweight => 'Your weight is below the healthy range. It is recommended to consult a health professional.';

  @override
  String get descNormal => 'Congratulations! Your weight is within the healthy range. Keep up your good habits.';

  @override
  String get descOverweight => 'Your weight is slightly above the healthy range. Consider making some lifestyle adjustments.';

  @override
  String get descObesity => 'Your weight is significantly above the healthy range. It is important to seek professional help.';

  @override
  String get descDefault => 'Consult a health professional for more information.';

  @override
  String get recommendationsUnderweight => 'Consult a nutritionist for an appropriate meal plan|Include foods rich in protein and healthy fats|Consider strength training to gain muscle mass|Avoid excessive stress that can affect your appetite';

  @override
  String get recommendationsNormal => 'Maintain a balanced diet rich in fruits and vegetables|Exercise regularly (at least 150 min/week)|Keep a regular meal schedule|Stay hydrated (8 glasses of water a day)';

  @override
  String get recommendationsOverweight => 'Gradually reduce food portions|Increase fiber and lean protein intake|Do regular cardiovascular exercise|Limit processed foods and sugary drinks';

  @override
  String get recommendationsObesity => 'Consult a doctor for a safe weight loss plan|Consider working with a professional nutritionist|Start with low-intensity exercise and increase gradually|Seek emotional support if necessary';

  @override
  String get recommendationsDefault => 'Consult a health professional for more information.';

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

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get profileDescription => 'To calculate your ideal weight and personalized calorie plan, we need some additional information';

  @override
  String get age => 'Age';

  @override
  String get yourAgeInYears => 'Your age in years';

  @override
  String get years => 'years';

  @override
  String get sex => 'Sex';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get physicalActivityLevel => 'Physical Activity Level';

  @override
  String get calculateMyPlan => 'Calculate My Plan';

  @override
  String get backToResults => 'Back to results';

  @override
  String get pleaseEnterAge => 'Please enter your age';

  @override
  String get ageRange => 'Age must be between 1 and 120 years';

  @override
  String get pleaseSelectSex => 'Please select your sex';

  @override
  String get pleaseSelectActivity => 'Please select your activity level';

  @override
  String get yourPersonalizedPlan => 'Your Personalized Plan';

  @override
  String get planGenerated => 'Plan Generated!';

  @override
  String get personalizedHealthPlan => 'This is your personalized health plan';

  @override
  String get healthyWeightRange => 'Healthy Weight Range';

  @override
  String get minimum => 'Minimum';

  @override
  String get ideal => 'Ideal';

  @override
  String get maximum => 'Maximum';

  @override
  String get yourNutritionalPlan => 'Your Nutritional Plan';

  @override
  String get basalMetabolism => 'Basal\nMetabolism';

  @override
  String get maintenanceCalories => 'Maintenance\nCalories';

  @override
  String get recommendedGoal => 'RECOMMENDED GOAL';

  @override
  String weeksToIdealWeight(Object weeks) {
    return 'You\'ll reach your ideal weight in ~$weeks weeks';
  }

  @override
  String get otherCalorieOptions => 'Other calorie options:';

  @override
  String get maintainWeight => 'Maintain weight';

  @override
  String get moderateWeightLoss => 'Moderate weight loss';

  @override
  String get rapidWeightLoss => 'Rapid weight loss';

  @override
  String get gainWeight => 'Gain weight';

  @override
  String get yourProfile => 'Your Profile';

  @override
  String get activityLevel => 'Activity Level';

  @override
  String get personalizedProfile => 'Personalized Profile';

  @override
  String get sedentaryActivity => 'Sedentary (little or no exercise)';

  @override
  String get lightActivity => 'Light (exercise 1-3 days/week)';

  @override
  String get moderateActivity => 'Moderate (exercise 3-5 days/week)';

  @override
  String get activeActivity => 'Active (exercise 6-7 days/week)';

  @override
  String get veryActiveActivity => 'Very Active (intense daily exercise)';

  @override
  String get personalizedHealthPlanTitle => 'Personalized Health Plan';

  @override
  String get personalizedNutritionalPlan => 'Personalized Nutritional Plan';

  @override
  String get profile => 'Profile:';

  @override
  String get basalMetabolismTMB => 'Basal Metabolism (BMR)';

  @override
  String get maintenanceCaloriesFull => 'Maintenance Calories';

  @override
  String get weeklyChangeModerate => '(-0.5 kg/week)';

  @override
  String get weeklyChangeRapid => '(-1 kg/week)';

  @override
  String get weeklyChangeGain => '(+0.3 kg/week)';

  @override
  String get calPerDay => 'cal/day';

  @override
  String get unlockFullPlan => 'Unlock Complete Plan';

  @override
  String get discoverIdealWeight => 'Discover your ideal weight and personalized calorie plan';

  @override
  String get featureMinMaxWeight => 'Minimum, ideal, and maximum healthy weight';

  @override
  String get featureDailyCalories => 'Personalized daily calorie goal';

  @override
  String get featureTimeToGoal => 'Estimated time to reach your goal';

  @override
  String get featureMultipleScenarios => 'Multiple calorie scenarios';

  @override
  String get featureOneTimePurchase => 'One-time purchase, no subscriptions';

  @override
  String oneTimePayment(Object price) {
    return 'One-time payment $price';
  }

  @override
  String get restorePurchase => 'Restore purchase';

  @override
  String get purchaseError => 'Could not process the purchase';

  @override
  String get historyTitle => 'History';

  @override
  String get viewHistory => 'View History';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get noMeasurements => 'No Measurements';

  @override
  String get noMeasurementsDesc => 'You haven\'t saved any measurements yet. Calculate your BMI and save the result to track your progress.';

  @override
  String get addMeasurement => 'Add Measurement';

  @override
  String totalMeasurements(Object count, Object limit) {
    return '$count of $limit measurements';
  }

  @override
  String get limitReached => 'You\'ve reached the limit. Upgrade to Premium to save more.';

  @override
  String get getPremium => 'Get Premium';

  @override
  String get saveMeasurement => 'Save Measurement';

  @override
  String get measurementSaved => 'Measurement saved successfully';

  @override
  String get errorSavingMeasurement => 'Error saving measurement';

  @override
  String get deleteConfirmTitle => 'Delete measurement?';

  @override
  String get deleteConfirmMessage => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get measurementDeleted => 'Measurement deleted';

  @override
  String get clearHistoryTitle => 'Clear history?';

  @override
  String get clearHistoryMessage => 'This will delete all saved measurements. This action cannot be undone.';

  @override
  String get clearAll => 'Delete All';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get measurementDetails => 'Measurement Details';

  @override
  String get close => 'Close';
}
