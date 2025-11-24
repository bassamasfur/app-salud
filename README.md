# Calculadora IMC - Flutter App

Una aplicación móvil multiplataforma desarrollada en Flutter para calcular el Índice de Masa Corporal (IMC) con una interfaz moderna y funcional.

## 🏗️ Arquitectura del Proyecto

Este proyecto implementa el patrón **MVC (Model-View-Controller)** con las siguientes buenas prácticas:

### 📁 Estructura de Carpetas

```
lib/
├── models/                 # Modelos de datos
│   └── persona.dart       # Clase Persona con lógica de IMC
├── views/                 # Vistas/Pantallas de la app
│   ├── bienvenida_page.dart      # Pantalla de inicio
│   ├── formulario_page.dart      # Formulario de captura de datos
│   └── resultado_page.dart       # Pantalla de resultados
├── controllers/           # Controladores de lógica de negocio
│   └── imc_controller.dart       # Controlador principal del IMC
└── main.dart             # Punto de entrada de la aplicación

assets/
└── images/               # Recursos de imágenes

test/
└── widget_test.dart      # Tests de la aplicación
```

## 🚀 Características

- ✅ **Arquitectura MVC**: Separación clara de responsabilidades
- ✅ **Navegación fluida**: Entre pantallas con rutas nombradas
- ✅ **Validación robusta**: De datos de entrada con mensajes descriptivos
- ✅ **UI/UX moderna**: Con gradientes, animaciones y diseño Material
- ✅ **Responsive Design**: Adaptable a diferentes tamaños de pantalla
- ✅ **Gestión de estado**: Con ChangeNotifier y AnimatedBuilder
- ✅ **Tests incluidos**: Verificación de funcionalidad básica
- ✅ **Multiplataforma**: Android, iOS, Web, Windows, macOS, Linux

## 📱 Pantallas de la Aplicación

### 1. Pantalla de Bienvenida (`bienvenida_page.dart`)
- Introducción a la aplicación
- Información sobre qué es el IMC
- Rangos de categorías del IMC con códigos de colores
- Botón para iniciar el cálculo

### 2. Formulario de Datos (`formulario_page.dart`)
- Captura de nombre, peso y altura
- Validaciones en tiempo real
- Interfaz intuitiva con iconos descriptivos
- Indicador de carga durante el procesamiento

### 3. Resultados del IMC (`resultado_page.dart`)
- Visualización del IMC calculado
- Categoría con código de colores (Bajo peso, Normal, Sobrepeso, Obesidad)
- Recomendaciones personalizadas
- Opciones para nuevo cálculo o volver al inicio

## 🧮 Lógica de Negocio

### Modelo Persona (`models/persona.dart`)
```dart
- Propiedades: nombre, peso, altura
- Cálculo: IMC = peso(kg) / altura(m)²
- Categorización según estándares de la OMS
- Validaciones de datos
- Serialización JSON
```

### Controlador IMC (`controllers/imc_controller.dart`)
```dart
- Gestión del estado de la aplicación
- Validación de formularios
- Cálculo asíncrono del IMC
- Manejo de errores
- Notificación de cambios a las vistas
```

## 🎨 Diseño y Tema

- **Colores principales**: Tonos azules (#2E86AB, #4A90E2)
- **Gradientes**: Para fondos de pantallas
- **Tipografía**: Material Design con pesos variables
- **Iconografía**: Material Icons
- **Componentes**: Cards, botones redondeados, campos de texto estilizados

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage
```

### Tests Incluidos:
- ✅ Verificación de construcción de la aplicación
- ✅ Navegación entre pantallas
- ✅ Presencia de elementos clave de UI

## 🚀 Cómo Ejecutar

### Prerrequisitos
- Flutter SDK (versión 3.9.2 o superior)
- Dart SDK
- Dispositivo/emulador Android o iOS (para móvil)
- Navegador web moderno (para web)

### Comandos de Ejecución

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en dispositivo/emulador
flutter run

# Ejecutar en web
flutter run -d web

# Ejecutar en escritorio (Windows)
flutter run -d windows

# Compilar para Android
flutter build apk

# Compilar para iOS
flutter build ios
```

## 📦 Dependencias

### Principales
- `flutter`: Framework principal
- `cupertino_icons`: Iconos iOS

### Desarrollo
- `flutter_test`: Testing framework
- `flutter_lints`: Reglas de linting
- `flutter_launcher_icons`: Generación de íconos personalizados

## 🎨 Personalización del Ícono

Para cambiar el logo de Flutter por un ícono personalizado del IMC:

1. **Crear ícono PNG de 512x512 píxeles** con temática IMC
2. **Guardar como** `assets/images/app_icon.png`
3. **Descomentar** la configuración de `flutter_icons` en `pubspec.yaml`
4. **Ejecutar** `flutter pub run flutter_launcher_icons:main`

Ver [ICON_SETUP.md](ICON_SETUP.md) para instrucciones detalladas.

## 🏥 Categorías del IMC

| Categoría | Rango IMC | Color | Descripción |
|-----------|-----------|-------|-------------|
| Bajo peso | < 18.5 | 🔵 Azul | Peso por debajo del recomendado |
| Normal | 18.5 - 24.9 | 🟢 Verde | Peso saludable |
| Sobrepeso | 25.0 - 29.9 | 🟠 Naranja | Peso por encima del recomendado |
| Obesidad | ≥ 30.0 | 🔴 Rojo | Peso significativamente elevado |

## 🔧 Configuración Adicional

### Assets
Los assets de imagen se configuran en `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

### Navegación
El sistema de rutas está configurado en `main.dart`:
```dart
routes: {
  '/': (context) => const BienvenidaPage(),
  '/formulario': (context) => const FormularioPage(),
  '/resultado': (context) => const ResultadoPage(),
}
```

## 🤝 Contribución

Este proyecto está estructurado para facilitar el mantenimiento y la extensión:

1. **Agregar nuevas funcionalidades**: Crear nuevos archivos en la carpeta correspondiente (models, views, controllers)
2. **Modificar UI**: Los cambios visuales se realizan en la carpeta `views/`
3. **Lógica de negocio**: Se modifica en `controllers/` y `models/`
4. **Tests**: Agregar tests en la carpeta `test/`

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---

**Desarrollado con ❤️ usando Flutter**
