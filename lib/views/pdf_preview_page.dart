import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/persona.dart';
import '../services/pdf_service.dart';
import '../l10n/app_localizations.dart';

/// Widget para mostrar vista previa del PDF antes de descargarlo
class PDFPreviewPage extends StatelessWidget {
  final Persona persona;

  const PDFPreviewPage({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.viewReport,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _descargarPDF(context, loc),
            tooltip: loc.viewReport,
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async => await _generarPDF(loc),
        allowSharing: false,
        allowPrinting: true,
        canChangePageFormat: false,
        canDebug: false,
        loadingWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E86AB)),
              ),
              const SizedBox(height: 16),
              Text(
                loc.generatingPreview,
                style: const TextStyle(fontSize: 16, color: Color(0xFF2E86AB)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Botón Cancelar
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E86AB),
                    side: const BorderSide(color: Color(0xFF2E86AB), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.close),
                  label: Text(
                    loc.viewReportCancel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Botón Descargar
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _descargarPDF(context, loc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: Text(
                    loc.viewReportSend,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Genera el PDF para la vista previa
  Future<Uint8List> _generarPDF(AppLocalizations loc) async {
    try {
      final pw.Document pdf = await PDFService.generarPDFParaVistaPrevia(
        persona,
        loc,
      );
      return Uint8List.fromList(await pdf.save());
    } catch (e) {
      debugPrint('Error generando vista previa PDF: $e');
      // Retornar un PDF vacío en caso de error
      final emptyPdf = pw.Document();
      emptyPdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text(
              'Error generando vista previa',
              style: pw.TextStyle(fontSize: 18, color: PdfColors.red),
            ),
          ),
        ),
      );
      return Uint8List.fromList(await emptyPdf.save());
    }
  }

  /// Descarga el PDF después de la vista previa
  Future<void> _descargarPDF(BuildContext context, AppLocalizations loc) async {
    try {
      // Generar el PDF como bytes
      final pdfDoc = await PDFService.generarPDFParaVistaPrevia(persona, loc);
      final pdfBytes = await pdfDoc.save();

      // Usar Printing.sharePdf para que el usuario elija dónde guardar o compartir
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename:
            'Informe_IMC_${persona.nombre}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.pdf',
      );
      if (!context.mounted) return;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar el PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
