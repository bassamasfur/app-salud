import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get appTitle;

  /// No description provided for @subtitle.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index'**
  String get subtitle;

  /// No description provided for @whatIsImcTitle.
  ///
  /// In en, this message translates to:
  /// **'What is BMI?'**
  String get whatIsImcTitle;

  /// No description provided for @whatIsImcDesc.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index is a measure that relates your weight and height to determine if you have a healthy weight.'**
  String get whatIsImcDesc;

  /// No description provided for @imcRanges.
  ///
  /// In en, this message translates to:
  /// **'BMI Ranges:'**
  String get imcRanges;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obesity.
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get obesity;

  /// No description provided for @calculateImc.
  ///
  /// In en, this message translates to:
  /// **'Calculate my BMI'**
  String get calculateImc;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by Bassam Asfur'**
  String get developedBy;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @enterYourData.
  ///
  /// In en, this message translates to:
  /// **'Enter your data'**
  String get enterYourData;

  /// No description provided for @completeInfoToCalculateImc.
  ///
  /// In en, this message translates to:
  /// **'Complete the information to calculate your BMI'**
  String get completeInfoToCalculateImc;

  /// No description provided for @enterHeightHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your height in meters (e.g., 1.75)'**
  String get enterHeightHint;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 70.5'**
  String get weightHint;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (m)'**
  String get height;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 1.75'**
  String get heightHint;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Result'**
  String get resultTitle;

  /// No description provided for @newCalculation.
  ///
  /// In en, this message translates to:
  /// **'New calculation'**
  String get newCalculation;

  /// No description provided for @interpretation.
  ///
  /// In en, this message translates to:
  /// **'INTERPRETATION'**
  String get interpretation;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String greeting(Object name);

  /// No description provided for @evaluationResults.
  ///
  /// In en, this message translates to:
  /// **'Your evaluation results'**
  String get evaluationResults;

  /// No description provided for @yourImcIs.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is:'**
  String get yourImcIs;

  /// No description provided for @weightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight: {weight} kg'**
  String weightWithUnit(Object weight);

  /// No description provided for @heightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Height: {height} m'**
  String heightWithUnit(Object height);

  /// No description provided for @descUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Your weight is below the healthy range. It is recommended to consult a health professional.'**
  String get descUnderweight;

  /// No description provided for @descNormal.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your weight is within the healthy range. Keep up your good habits.'**
  String get descNormal;

  /// No description provided for @descOverweight.
  ///
  /// In en, this message translates to:
  /// **'Your weight is slightly above the healthy range. Consider making some lifestyle adjustments.'**
  String get descOverweight;

  /// No description provided for @descObesity.
  ///
  /// In en, this message translates to:
  /// **'Your weight is significantly above the healthy range. It is important to seek professional help.'**
  String get descObesity;

  /// No description provided for @descDefault.
  ///
  /// In en, this message translates to:
  /// **'Consult a health professional for more information.'**
  String get descDefault;

  /// No description provided for @recommendationsUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Consult a nutritionist for an appropriate meal plan|Include foods rich in protein and healthy fats|Consider strength training to gain muscle mass|Avoid excessive stress that can affect your appetite'**
  String get recommendationsUnderweight;

  /// No description provided for @recommendationsNormal.
  ///
  /// In en, this message translates to:
  /// **'Maintain a balanced diet rich in fruits and vegetables|Exercise regularly (at least 150 min/week)|Keep a regular meal schedule|Stay hydrated (8 glasses of water a day)'**
  String get recommendationsNormal;

  /// No description provided for @recommendationsOverweight.
  ///
  /// In en, this message translates to:
  /// **'Gradually reduce food portions|Increase fiber and lean protein intake|Do regular cardiovascular exercise|Limit processed foods and sugary drinks'**
  String get recommendationsOverweight;

  /// No description provided for @recommendationsObesity.
  ///
  /// In en, this message translates to:
  /// **'Consult a doctor for a safe weight loss plan|Consider working with a professional nutritionist|Start with low-intensity exercise and increase gradually|Seek emotional support if necessary'**
  String get recommendationsObesity;

  /// No description provided for @recommendationsDefault.
  ///
  /// In en, this message translates to:
  /// **'Consult a health professional for more information.'**
  String get recommendationsDefault;

  /// No description provided for @calculateAnotherImc.
  ///
  /// In en, this message translates to:
  /// **'Calculate another BMI'**
  String get calculateAnotherImc;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Title for the PDF report
  ///
  /// In en, this message translates to:
  /// **'BODY MASS INDEX (BMI) REPORT'**
  String get pdfTitle;

  /// Section title for patient info in PDF
  ///
  /// In en, this message translates to:
  /// **'PATIENT INFORMATION'**
  String get pdfPatientInfo;

  /// Section title for BMI result in PDF
  ///
  /// In en, this message translates to:
  /// **'BMI RESULT'**
  String get pdfResult;

  /// Section title for BMI reference table in PDF
  ///
  /// In en, this message translates to:
  /// **'BMI Reference Table'**
  String get pdfReferenceTable;

  /// Date label for PDF
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String pdfDate(Object date);

  /// Category column label in PDF table
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Loading message for PDF preview
  ///
  /// In en, this message translates to:
  /// **'Generating preview...'**
  String get generatingPreview;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
