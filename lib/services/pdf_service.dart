import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/persona.dart';
import '../l10n/app_localizations.dart';

/// Servicio para generar informes en PDF de los resultados del IMC
class PDFService {
  /// Genera un PDF para vista previa (sin guardar)
  static Future<pw.Document> generarPDFParaVistaPrevia(
    Persona persona,
    AppLocalizations loc,
  ) async {
    return _crearDocumentoPDF(persona, loc);
  }

  /// Genera un informe PDF completo con los datos del IMC
  static Future<bool> generarInformePDF(
    Persona persona,
    AppLocalizations loc,
  ) async {
    try {
      // Solicitar permisos de almacenamiento
      if (!await _solicitarPermisos()) {
        return false;
      }

      // Crear el documento PDF
      final pdf = _crearDocumentoPDF(persona, loc);

      // Guardar el archivo
      final fecha = DateTime.now();
      final String fileName =
          'Informe_IMC_${persona.nombre}_${fecha.day}-${fecha.month}-${fecha.year}.pdf'; // prefer_interpolation_to_compose_strings
      return await _guardarPDF(pdf, fileName);
    } catch (e) {
      debugPrint('Error generando PDF: $e');
      return false;
    }
  }

  /// Crea el documento PDF con todos los elementos
  static pw.Document _crearDocumentoPDF(Persona persona, AppLocalizations loc) {
    final pdf = pw.Document();

    // Calcular datos necesarios
    final imc = persona.calcularIMC();
    final categoria = persona.obtenerCategoriaIMC();
    final fecha = DateTime.now();
    final recomendaciones = _obtenerRecomendaciones(categoria, loc);

    // Crear las páginas del PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Encabezado
          _construirEncabezado(loc),

          pw.SizedBox(height: 30),

          // Información del paciente
          _construirInfoPaciente(persona, fecha, loc),

          pw.SizedBox(height: 30),

          // Resultados del IMC
          _construirResultadosIMC(imc, categoria, loc),

          pw.SizedBox(height: 30),

          // Interpretación
          _construirInterpretacion(categoria, loc),

          pw.SizedBox(height: 30),

          // Recomendaciones
          _construirRecomendaciones(recomendaciones, loc),

          pw.SizedBox(height: 30),

          // Tabla de referencia
          _construirTablaReferencia(loc),

          pw.SizedBox(height: 20),

          // Pie de página
          _construirPiePagina(loc),
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

  /// Guarda el documento PDF en el almacenamiento local
  static Future<bool> _guardarPDF(pw.Document pdf, String fileName) async {
    try {
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      return true;
    } catch (e) {
      debugPrint('Error guardando PDF: $e');
      return false;
    }
  }

  /// Construye el encabezado del documento PDF
  static pw.Widget _construirEncabezado(AppLocalizations loc) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            loc.pdfTitle,
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
  static pw.Widget _construirInfoPaciente(
    Persona persona,
    DateTime fecha,
    AppLocalizations loc,
  ) {
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
            loc.pdfPatientInfo,
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
                '${loc.name}: ${persona.nombre}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                loc.pdfDate('${fecha.day}/${fecha.month}/${fecha.year}'),
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                loc.weightWithUnit(persona.peso.toStringAsFixed(1)),
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                loc.heightWithUnit(persona.altura.toStringAsFixed(2)),
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la sección de resultados del IMC
  static pw.Widget _construirResultadosIMC(
    double imc,
    String categoria,
    AppLocalizations loc,
  ) {
    final color = _obtenerColorCategoria(categoria);
    final categoriaLocalizada = _getCategoriaLocalizada(categoria, loc);
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
            loc.pdfResult,
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
            categoriaLocalizada.toUpperCase(),
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
  static pw.Widget _construirInterpretacion(
    String categoria,
    AppLocalizations loc,
  ) {
    final interpretacion = _obtenerInterpretacion(categoria, loc);
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
            loc.interpretation,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(interpretacion, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Construye la sección de recomendaciones
  static pw.Widget _construirRecomendaciones(
    List<String> recomendaciones,
    AppLocalizations loc,
  ) {
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
            loc.recommendations,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 8),
          ...recomendaciones.map(
            (rec) =>
                pw.Bullet(text: rec, style: const pw.TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  /// Construye la tabla de referencia de IMC
  static pw.Widget _construirTablaReferencia(AppLocalizations loc) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            loc.pdfReferenceTable,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 13,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      loc.category,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      loc.imcRanges,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(loc.underweight),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('< 18.5'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(loc.normal),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('18.5 - 24.9'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(loc.overweight),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('25 - 29.9'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(loc.obesity),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('≥ 30'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Pie de página
  static pw.Widget _construirPiePagina(AppLocalizations loc) {
    return pw.Center(
      child: pw.Text(
        loc.developedBy,
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  /// Traducción de categoría para PDF
  static String _getCategoriaLocalizada(
    String categoria,
    AppLocalizations loc,
  ) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.underweight;
      case 'normal':
        return loc.normal;
      case 'sobrepeso':
        return loc.overweight;
      case 'obesidad':
        return loc.obesity;
      default:
        return categoria;
    }
  }

  /// Traducción de interpretación para PDF
  static String _obtenerInterpretacion(String categoria, AppLocalizations loc) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.descUnderweight;
      case 'normal':
        return loc.descNormal;
      case 'sobrepeso':
        return loc.descOverweight;
      case 'obesidad':
        return loc.descObesity;
      default:
        return loc.descDefault;
    }
  }

  /// Traducción de recomendaciones para PDF
  static List<String> _obtenerRecomendaciones(
    String categoria,
    AppLocalizations loc,
  ) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return loc.recommendationsUnderweight.split('|');
      case 'normal':
        return loc.recommendationsNormal.split('|');
      case 'sobrepeso':
        return loc.recommendationsOverweight.split('|');
      case 'obesidad':
        return loc.recommendationsObesity.split('|');
      default:
        return [loc.recommendationsDefault];
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
}
