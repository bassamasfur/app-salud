// Test básico para la aplicación IMC
// Verifica que la aplicación se construya correctamente y muestre la página de bienvenida

import 'package:flutter_test/flutter_test.dart';

import 'package:app_imc/main.dart';

void main() {
  testWidgets('La aplicación muestra la página de bienvenida', (
    WidgetTester tester,
  ) async {
    // Construir la aplicación y disparar un frame
    await tester.pumpWidget(const IMCApp());

    // Verificar que aparece el título de la aplicación
    expect(find.text('Calculadora IMC'), findsOneWidget);

    // Verificar que aparece el subtítulo
    expect(find.text('Índice de Masa Corporal'), findsOneWidget);

    // Verificar que aparece el botón para calcular IMC
    expect(find.text('Calcular mi IMC'), findsOneWidget);

    // Verificar que aparece la información sobre IMC
    expect(find.text('¿Qué es el IMC?'), findsOneWidget);
  });

  testWidgets('Navegación desde bienvenida a formulario', (
    WidgetTester tester,
  ) async {
    // Construir la aplicación
    await tester.pumpWidget(const IMCApp());

    // Hacer scroll para asegurar que el botón esté visible
    await tester.ensureVisible(find.text('Calcular mi IMC'));
    await tester.pumpAndSettle();

    // Encontrar y tocar el botón "Calcular mi IMC"
    await tester.tap(find.text('Calcular mi IMC'));
    await tester.pumpAndSettle();

    // Verificar que navegamos a la página del formulario
    expect(find.text('Datos Personales'), findsOneWidget);
    expect(find.text('Ingresa tus datos'), findsOneWidget);
  });
}
