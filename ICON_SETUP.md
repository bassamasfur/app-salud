# Instrucciones para Cambiar el Ícono de la Aplicación

## 📱 Cómo Reemplazar el Logo de Flutter

Para cambiar el logo que aparece al cargar la aplicación, sigue estos pasos:

### 1. 🎨 Crear el Ícono PNG

Necesitas crear un archivo PNG de **512x512 píxeles** con el diseño del IMC:

**Opción A: Usando un editor gráfico (recomendado)**
- Abrir GIMP, Photoshop, Canva o similar
- Crear un lienzo de 512x512 píxeles
- Fondo azul: `#2E86AB` con esquinas redondeadas
- Agregar ícono de balanza o peso en color blanco
- Agregar texto "IMC" prominente en blanco
- Agregar subtítulo "Calculator" más pequeño
- Guardar como `app_icon.png`

**Opción B: Convertir el SVG incluido**
- Usar el archivo `app_icon.svg` incluido en este proyecto
- Convertir a PNG usando Inkscape, convertidor online o similar
- Asegurar dimensiones exactas: 512x512 píxeles

### 2. 📁 Colocar el Archivo

Guardar el archivo como:
```
assets/images/app_icon.png
```

### 3. ⚙️ Configurar pubspec.yaml

Descomentar la sección de `flutter_icons` en `pubspec.yaml`:

```yaml
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/app_icon.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/images/app_icon.png"
  windows:
    generate: true
    image_path: "assets/images/app_icon.png"
  macos:
    generate: true
    image_path: "assets/images/app_icon.png"
```

### 4. 🚀 Generar los Íconos

Ejecutar en terminal:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

### 5. 🔄 Reinstalar la Aplicación

```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 Características del Ícono Ideal

- **Tamaño**: 512x512 píxeles
- **Formato**: PNG con fondo sólido
- **Colores**: 
  - Fondo: `#2E86AB` (azul de la app)
  - Íconos: Blanco
  - Texto: Blanco
- **Elementos**: 
  - Ícono relacionado con peso/salud/IMC
  - Texto "IMC" prominente
  - Esquinas redondeadas
- **Estilo**: Limpio, profesional, legible en tamaños pequeños

## 📱 Resultado

Una vez configurado, el ícono personalizado aparecerá:
- En la pantalla de inicio del dispositivo
- En la splash screen al abrir la app
- En el app switcher/multitarea
- En todas las plataformas (Android, iOS, Web, Desktop)

## 🔧 Troubleshooting

Si el ícono no cambia:
1. Verificar que el archivo `app_icon.png` existe
2. Verificar las dimensiones exactas (512x512)
3. Limpiar y reconstruir: `flutter clean && flutter pub get`
4. Desinstalar y reinstalar la app completamente