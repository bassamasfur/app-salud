import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/persona.dart';
import '../services/pdf_service.dart';

/// Widget para mostrar vista previa del PDF antes de descargarlo
class PDFPreviewPage extends StatelessWidget {
  final Persona persona;

  const PDFPreviewPage({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vista Previa del Informe',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _descargarPDF(context),
            tooltip: 'Descargar PDF',
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async => await _generarPDF(),
        allowSharing: false,
        allowPrinting: true,
        canChangePageFormat: false,
        canDebug: false,
        loadingWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E86AB)),
              ),
              SizedBox(height: 16),
              Text(
                'Generando vista previa...',
                style: TextStyle(fontSize: 16, color: Color(0xFF2E86AB)),
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
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Botón Descargar
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _descargarPDF(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'Descargar Informe',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
  Future<Uint8List> _generarPDF() async {
    try {
      final pw.Document pdf = await PDFService.generarPDFParaVistaPrevia(
        persona,
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
  Future<void> _descargarPDF(BuildContext context) async {
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Descargando informe PDF...'),
            ],
          ),
        );
      },
    );

    try {
      // Generar y guardar el PDF
      final bool success = await PDFService.generarInformePDF(persona);

      // Cerrar el diálogo de carga
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Mostrar resultado y cerrar vista previa
      if (context.mounted) {
        if (success) {
          // Cerrar la vista previa
          Navigator.of(context).pop();

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text('¡Informe PDF descargado correctamente!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Error al descargar el PDF'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      // Cerrar el diálogo de carga en caso de error
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
