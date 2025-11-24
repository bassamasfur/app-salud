import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/persona.dart';

/// Servicio para generar informes en PDF de los resultados del IMC
class PDFService {
  /// Genera un PDF para vista previa (sin guardar)
  static Future<pw.Document> generarPDFParaVistaPrevia(Persona persona) async {
    return _crearDocumentoPDF(persona);
  }

  /// Genera un informe PDF completo con los datos del IMC
  static Future<bool> generarInformePDF(Persona persona) async {
    try {
      // Solicitar permisos de almacenamiento
      if (!await _solicitarPermisos()) {
        return false;
      }

      // Crear el documento PDF
      final pdf = _crearDocumentoPDF(persona);

      // Guardar el archivo
      final fecha = DateTime.now();
      final String fileName =
          'Informe_IMC_${persona.nombre}_${fecha.day}-${fecha.month}-${fecha.year}.pdf';
      return await _guardarPDF(pdf, fileName);
    } catch (e) {
      debugPrint('Error generando PDF: $e');
      return false;
    }
  }

  /// Crea el documento PDF con todos los elementos
  static pw.Document _crearDocumentoPDF(Persona persona) {
    final pdf = pw.Document();

    // Calcular datos necesarios
    final imc = persona.calcularIMC();
    final categoria = persona.obtenerCategoriaIMC();
    final fecha = DateTime.now();
    final recomendaciones = _obtenerRecomendaciones(categoria);

    // Crear las páginas del PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Encabezado
          _construirEncabezado(),

          pw.SizedBox(height: 30),

          // Información del paciente
          _construirInfoPaciente(persona, fecha),

          pw.SizedBox(height: 30),

          // Resultados del IMC
          _construirResultadosIMC(imc, categoria),

          pw.SizedBox(height: 30),

          // Interpretación
          _construirInterpretacion(categoria),

          pw.SizedBox(height: 30),

          // Recomendaciones
          _construirRecomendaciones(recomendaciones),

          pw.SizedBox(height: 30),

          // Tabla de referencia
          _construirTablaReferencia(),

          pw.SizedBox(height: 20),

          // Pie de página
          _construirPiePagina(),
        ],
      ),
    );

    return pdf;
  }

  /// Solicita los permisos necesarios para guardar archivos
  static Future<bool> _solicitarPermisos() async {
    // Al usar el directorio de la aplicación, no necesitamos permisos especiales
    return true;
  }

  /// Construye el encabezado del documento PDF
  static pw.Widget _construirEncabezado() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'INFORME DE ÍNDICE DE MASA CORPORAL (IMC)',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Center(
          child: pw.Container(height: 2, width: 300, color: PdfColors.blue300),
        ),
      ],
    );
  }

  /// Construye la sección de información del paciente
  static pw.Widget _construirInfoPaciente(Persona persona, DateTime fecha) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INFORMACIÓN DEL PACIENTE',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Nombre: ${persona.nombre}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Fecha: ${fecha.day}/${fecha.month}/${fecha.year}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Peso: ${persona.peso.toStringAsFixed(1)} kg',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Altura: ${persona.altura.toStringAsFixed(2)} m',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la sección de resultados del IMC
  static pw.Widget _construirResultadosIMC(double imc, String categoria) {
    final color = _obtenerColorCategoria(categoria);

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: color, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'RESULTADO DEL IMC',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: color,
            ),
            child: pw.Center(
              child: pw.Text(
                imc.toStringAsFixed(1),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            categoria.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de interpretación
  static pw.Widget _construirInterpretacion(String categoria) {
    final interpretacion = _obtenerInterpretacion(categoria);

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue200),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INTERPRETACIÓN',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            interpretacion,
            style: const pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  /// Construye la sección de recomendaciones
  static pw.Widget _construirRecomendaciones(List<String> recomendaciones) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'RECOMENDACIONES',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        ...recomendaciones.map(
          (recomendacion) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 4,
                  height: 4,
                  margin: const pw.EdgeInsets.only(top: 6, right: 8),
                  decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: PdfColors.blue600,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    recomendacion,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Construye la tabla de referencia del IMC
  static pw.Widget _construirTablaReferencia() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'TABLA DE REFERENCIA IMC (OMS)',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Categoría',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Rango IMC',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Bajo peso',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '< 18.5',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Peso normal',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '18.5 - 24.9',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Sobrepeso',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '25.0 - 29.9',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Obesidad',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '≥ 30.0',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el pie de página
  static pw.Widget _construirPiePagina() {
    return pw.Column(
      children: [
        pw.Container(height: 1, color: PdfColors.grey400),
        pw.SizedBox(height: 10),
        pw.Text(
          'NOTA: Este informe es de carácter informativo. Consulte con un profesional de la salud para evaluación médica completa.',
          style: pw.TextStyle(
            fontSize: 9,
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey600,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Generado por Calculadora IMC - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  /// Guarda el PDF en el almacenamiento del dispositivo
  static Future<bool> _guardarPDF(pw.Document pdf, String fileName) async {
    try {
      final Uint8List bytes = await pdf.save();

      // Usar directorio de la aplicación (más seguro y compatible)
      final Directory directory = await getApplicationDocumentsDirectory();

      final String path = '${directory.path}/$fileName';
      final File file = File(path);
      await file.writeAsBytes(bytes);

      debugPrint('PDF guardado en: $path');
      return true;
    } catch (e) {
      debugPrint('Error guardando PDF: $e');
      return false;
    }
  }

  /// Obtiene el color asociado a cada categoría
  static PdfColor _obtenerColorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return PdfColors.blue;
      case 'peso normal':
      case 'normal':
        return PdfColors.green;
      case 'sobrepeso':
        return PdfColors.orange;
      case 'obesidad':
        return PdfColors.red;
      default:
        return PdfColors.grey;
    }
  }

  /// Obtiene la interpretación detallada de cada categoría
  static String _obtenerInterpretacion(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return 'Su peso está por debajo del rango considerado saludable. Esto podría indicar desnutrición o problemas de salud subyacentes. Es recomendable consultar con un profesional de la salud para evaluar las causas y desarrollar un plan de alimentación adecuado.';
      case 'peso normal':
      case 'normal':
        return '¡Felicidades! Su peso está dentro del rango considerado saludable. Esto indica que tiene un equilibrio adecuado entre su peso y estatura. Mantenga sus hábitos saludables de alimentación y ejercicio para conservar este estado.';
      case 'sobrepeso':
        return 'Su peso está ligeramente por encima del rango considerado saludable. Aunque no es obesidad, es importante tomar medidas preventivas para evitar problemas de salud futuros. Considere hacer ajustes en su dieta y aumentar su actividad física.';
      case 'obesidad':
        return 'Su peso está significativamente por encima del rango saludable. La obesidad está asociada con mayor riesgo de diabetes, enfermedades cardíacas, hipertensión y otros problemas de salud. Es importante buscar ayuda profesional para desarrollar un plan de pérdida de peso seguro y efectivo.';
      default:
        return 'Resultado no disponible. Consulte con un profesional de la salud para una evaluación completa.';
    }
  }

  /// Obtiene las recomendaciones específicas para cada categoría
  static List<String> _obtenerRecomendaciones(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return [
          'Consulte con un nutricionista para desarrollar un plan de alimentación que le ayude a ganar peso de forma saludable.',
          'Incluya alimentos ricos en proteínas, grasas saludables y carbohidratos complejos en su dieta.',
          'Considere realizar ejercicios de fuerza para aumentar la masa muscular.',
          'Evite el estrés excesivo que puede afectar su apetito y digestión.',
          'Realice controles médicos regulares para descartar problemas de salud subyacentes.',
        ];
      case 'peso normal':
      case 'normal':
        return [
          'Mantenga una dieta equilibrada rica en frutas, verduras, proteínas magras y granos enteros.',
          'Realice actividad física regular: al menos 150 minutos de ejercicio moderado por semana.',
          'Mantenga horarios regulares de comidas y evite saltarse las comidas principales.',
          'Hidrátese adecuadamente bebiendo al menos 8 vasos de agua al día.',
          'Duerma entre 7-9 horas diarias para mantener un metabolismo saludable.',
          'Realice controles de salud preventivos anualmente.',
        ];
      case 'sobrepeso':
        return [
          'Reduzca gradualmente las porciones de comida y evite las segundas porciones.',
          'Incremente el consumo de fibra mediante frutas, verduras y granos enteros.',
          'Realice ejercicio cardiovascular regular: caminatas, natación o ciclismo.',
          'Limite el consumo de alimentos procesados, bebidas azucaradas y comida rápida.',
          'Lleve un registro de sus comidas para identificar patrones alimentarios.',
          'Busque apoyo de familiares y amigos en su proceso de cambio de hábitos.',
        ];
      case 'obesidad':
        return [
          'Consulte con un médico para desarrollar un plan integral y seguro de pérdida de peso.',
          'Trabaje con un nutricionista profesional para crear un plan alimentario personalizado.',
          'Inicie con ejercicio de baja intensidad y aumente gradualmente la duración e intensidad.',
          'Considere terapia conductual para abordar hábitos alimentarios y emocionales.',
          'Evalúe con su médico la necesidad de tratamientos adicionales o intervenciones.',
          'Busque grupos de apoyo para personas con objetivos similares de pérdida de peso.',
        ];
      default:
        return [
          'Consulte con un profesional de la salud para obtener recomendaciones personalizadas.',
        ];
    }
  }
}
