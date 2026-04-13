import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/persona.dart';
import '../models/enums.dart';
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

    // Verificar si hay datos premium disponibles
    final tieneDatosPremium =
        persona.edad != null &&
        persona.sexo != null &&
        persona.nivelActividad != null;

    Map<String, dynamic>? pesoIdeal;
    Map<String, dynamic>? metasCalorias;

    if (tieneDatosPremium) {
      pesoIdeal = persona.calcularPesoIdeal();
      metasCalorias = persona.calcularMetasCalorias(loc);
    }

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

          // SECCIONES PREMIUM (si están disponibles)
          if (tieneDatosPremium) ...[
            pw.SizedBox(height: 30),
            _construirDivisor(),
            pw.SizedBox(height: 20),
            _construirTituloPremium(loc),
            pw.SizedBox(height: 20),
            _construirPesoIdeal(pesoIdeal!, loc),
            pw.SizedBox(height: 20),
            _construirPlanNutricional(metasCalorias!, persona, loc),
          ],

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
          // Datos adicionales premium (si están disponibles)
          if (persona.edad != null ||
              persona.sexo != null ||
              persona.nivelActividad != null) ...[
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (persona.edad != null)
                  pw.Text(
                    'Edad: ${persona.edad} años',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                if (persona.sexo != null)
                  pw.Text(
                    'Sexo: ${persona.sexo!.name == 'hombre' ? 'Hombre' : 'Mujer'}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
              ],
            ),
            if (persona.nivelActividad != null) ...[
              pw.SizedBox(height: 5),
              pw.Text(
                'Nivel de Actividad: ${persona.nivelActividad!.descripcion}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ],
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

  /// Construye un divisor visual para separar secciones
  static pw.Widget _construirDivisor() {
    return pw.Column(
      children: [
        pw.Container(height: 2, color: PdfColors.green400),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
          ),
          child: pw.Text(
            '★ ANÁLISIS PREMIUM ★',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
        ),
      ],
    );
  }

  /// Título de la sección premium
  static pw.Widget _construirTituloPremium(AppLocalizations loc) {
    return pw.Center(
      child: pw.Text(
        loc.personalizedHealthPlanTitle,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.green800,
        ),
      ),
    );
  }

  /// Construye la sección de peso ideal
  static pw.Widget _construirPesoIdeal(
    Map<String, dynamic> pesoIdeal,
    AppLocalizations loc,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        border: pw.Border.all(color: PdfColors.red200, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 30,
                height: 30,
                decoration: const pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  color: PdfColors.red,
                ),
                child: pw.Center(
                  child: pw.Text(
                    '♥',
                    style: pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                loc.healthyWeightRange,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red800,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _construirItemPeso(
                loc.minimum,
                pesoIdeal['pesoMinimo'],
                PdfColors.orange,
              ),
              _construirItemPeso(
                loc.ideal,
                pesoIdeal['pesoIdeal'],
                PdfColors.green,
              ),
              _construirItemPeso(
                loc.maximum,
                pesoIdeal['pesoMaximo'],
                PdfColors.orange,
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Text(
              pesoIdeal['mensaje'],
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un item de peso individual
  static pw.Widget _construirItemPeso(
    String label,
    double peso,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${peso.toStringAsFixed(1)} kg',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Construye la sección del plan nutricional
  static pw.Widget _construirPlanNutricional(
    Map<String, dynamic> metasCalorias,
    Persona persona,
    AppLocalizations loc,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.orange50,
        border: pw.Border.all(color: PdfColors.orange200, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 30,
                height: 30,
                decoration: const pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  color: PdfColors.orange,
                ),
                child: pw.Center(
                  child: pw.Text(
                    '🔥',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                loc.personalizedNutritionalPlan,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange800,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),

          // Información del perfil
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${loc.profile} ${persona.edad} ${loc.years} • ${_getSexoTexto(persona.sexo!, loc)} • ${_getNivelActividadTexto(persona.nivelActividad!, loc)}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 12),

          // TMB y TDEE
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _construirItemCaloria(
                loc.basalMetabolismTMB,
                metasCalorias['tmb'],
                PdfColors.blue,
              ),
              _construirItemCaloria(
                loc.maintenanceCaloriesFull,
                metasCalorias['tdee'],
                PdfColors.purple,
              ),
            ],
          ),

          pw.SizedBox(height: 15),

          // Meta Recomendada (destacada)
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.green,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  '🎯 ${loc.recommendedGoal}',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  metasCalorias['recomendacion'],
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.white),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '${metasCalorias['metaRecomendada']} ${loc.calPerDay}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                if (metasCalorias['semanasEstimadas'] > 0) ...[
                  pw.SizedBox(height: 6),
                  pw.Text(
                    '⏱️ ${loc.weeksToIdealWeight(metasCalorias['semanasEstimadas'])}',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),

          pw.SizedBox(height: 15),

          // Otras opciones
          pw.Text(
            loc.otherCalorieOptions,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 8),
          _construirOpcionCaloria(
            '🟢 ${loc.maintainWeight}',
            metasCalorias['mantenimiento'],
            null,
            loc,
          ),
          _construirOpcionCaloria(
            '💚 ${loc.moderateWeightLoss}',
            metasCalorias['perderModerado'],
            loc.weeklyChangeModerate,
            loc,
          ),
          _construirOpcionCaloria(
            '💙 ${loc.rapidWeightLoss}',
            metasCalorias['perderRapido'],
            loc.weeklyChangeRapid,
            loc,
          ),
          _construirOpcionCaloria(
            '💛 ${loc.gainWeight}',
            metasCalorias['ganarPeso'],
            loc.weeklyChangeGain,
            loc,
          ),
        ],
      ),
    );
  }

  /// Construye un item de caloría individual
  static pw.Widget _construirItemCaloria(
    String label,
    int calorias,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '$calorias cal',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Construye una opción de caloría
  static pw.Widget _construirOpcionCaloria(
    String label,
    int calorias,
    String? detalle,
    AppLocalizations loc,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
                if (detalle != null)
                  pw.Text(
                    detalle,
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
              ],
            ),
          ),
          pw.Text(
            '$calorias ${loc.calPerDay}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
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

  /// Obtiene el texto traducido para el sexo
  static String _getSexoTexto(Sexo sexo, AppLocalizations loc) {
    switch (sexo) {
      case Sexo.hombre:
        return loc.male;
      case Sexo.mujer:
        return loc.female;
    }
  }

  /// Obtiene el texto traducido para un nivel de actividad
  static String _getNivelActividadTexto(
    NivelActividad nivel,
    AppLocalizations loc,
  ) {
    switch (nivel) {
      case NivelActividad.sedentario:
        return loc.sedentaryActivity;
      case NivelActividad.ligero:
        return loc.lightActivity;
      case NivelActividad.moderado:
        return loc.moderateActivity;
      case NivelActividad.activo:
        return loc.activeActivity;
      case NivelActividad.muyActivo:
        return loc.veryActiveActivity;
    }
  }
}
