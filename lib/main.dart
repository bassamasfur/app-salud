import 'package:flutter/material.dart';
import 'views/splash_page.dart';
import 'views/bienvenida_page.dart';
import 'views/formulario_page.dart';
import 'views/resultado_page.dart';

void main() {
  runApp(const IMCApp());
}

/// Aplicación principal para calcular el Índice de Masa Corporal
/// Implementa arquitectura MVC con navegación entre pantallas
class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema personalizado con colores azules
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2E86AB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E86AB),
          brightness: Brightness.light,
        ),

        // Configuración de AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E86AB),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        // Configuración de botones
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

        // Configuración de campos de texto
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E86AB), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),

        // Configuración de Cards
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        // Configuración de tipografía
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

        // Configuración de iconos
        iconTheme: const IconThemeData(color: Color(0xFF2E86AB)),
      ),

      // Ruta inicial
      initialRoute: '/',

      // Configuración de rutas
      routes: {
        '/': (context) => const SplashPage(),
        '/bienvenida': (context) => const BienvenidaPage(),
        '/formulario': (context) => const FormularioPage(),
        '/resultado': (context) => const ResultadoPage(),
      },

      // Manejo de rutas no encontradas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const SplashPage());
      },
    );
  }
}
