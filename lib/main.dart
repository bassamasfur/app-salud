import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/splash_page.dart';
import 'views/bienvenida_page.dart';
import 'views/formulario_page.dart';
import 'views/resultado_page.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const IMCApp());
}

/// Aplicación principal para calcular el Índice de Masa Corporal
/// Implementa arquitectura MVC con navegación entre pantallas
class IMCApp extends StatefulWidget {
  const IMCApp({super.key});

  @override
  State<IMCApp> createState() => _IMCAppState();
}

class _IMCAppState extends State<IMCApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2E86AB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E86AB),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E86AB),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E86AB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2E86AB)),
      ),
      locale: _locale,
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(setLocale: setLocale),
        '/bienvenida': (context) =>
            BienvenidaPage(setLocale: setLocale, currentLocale: _locale),
        '/formulario': (context) => const FormularioPage(),
        '/resultado': (context) => const ResultadoPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => SplashPage(setLocale: setLocale),
        );
      },
    );
  }
}
