import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medicion_imc.dart';
import '../models/enums.dart';
import '../services/storage_service.dart';
import '../services/purchase_service.dart';
import '../l10n/app_localizations.dart';

/// Pantalla que muestra el historial de mediciones de IMC
class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final PurchaseService _purchaseService = PurchaseService();
  List<MedicionIMC> _mediciones = [];
  bool _isLoading = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);

    await _purchaseService.initialize();
    _isPremium = _purchaseService.hasPurchased;

    final mediciones = await StorageService.obtenerMediciones();

    setState(() {
      _mediciones = mediciones;
      _isLoading = false;
    });
  }

  Future<void> _eliminarMedicion(int index) async {
    final loc = AppLocalizations.of(context)!;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deleteConfirmTitle),
        content: Text(loc.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final exito = await StorageService.eliminarMedicion(index);
      if (exito) {
        _cargarDatos();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.measurementDeleted)));
        }
      }
    }
  }

  Future<void> _limpiarHistorial() async {
    final loc = AppLocalizations.of(context)!;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.clearHistoryTitle),
        content: Text(loc.clearHistoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.clearAll),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final exito = await StorageService.limpiarHistorial();
      if (exito) {
        _cargarDatos();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.historyCleared)));
        }
      }
    }
  }

  Color _obtenerColorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'bajo peso':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'sobrepeso':
        return Colors.orange;
      case 'obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _obtenerNombreCategoria(String categoria, AppLocalizations loc) {
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final limite = StorageService.obtenerLimite(_isPremium);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.historyTitle),
        actions: [
          if (_mediciones.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: loc.clearHistory,
              onPressed: _limpiarHistorial,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mediciones.isEmpty
          ? _construirVistaVacia(loc)
          : Column(
              children: [
                _construirEncabezado(loc, limite),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _cargarDatos,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _mediciones.length,
                      itemBuilder: (context, index) {
                        final medicion = _mediciones[index];
                        return _construirTarjetaMedicion(medicion, index, loc);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _construirVistaVacia(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              loc.noMeasurements,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              loc.noMeasurementsDesc,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/formulario');
              },
              icon: const Icon(Icons.add),
              label: Text(loc.addMeasurement),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirEncabezado(AppLocalizations loc, int limite) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.totalMeasurements(_mediciones.length, limite),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                if (!_isPremium && _mediciones.length >= limite)
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          loc.limitReached,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!_isPremium)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/datos_adicionales');
              },
              icon: const Icon(Icons.upgrade, size: 18),
              label: Text(loc.getPremium),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
              ),
            ),
        ],
      ),
    );
  }

  Widget _construirTarjetaMedicion(
    MedicionIMC medicion,
    int index,
    AppLocalizations loc,
  ) {
    final color = _obtenerColorCategoria(medicion.categoria);
    final nombreCategoria = _obtenerNombreCategoria(medicion.categoria, loc);
    final formato = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          _mostrarDetallesMedicion(medicion, loc);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicion.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formato.format(medicion.fecha),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[400],
                    onPressed: () => _eliminarMedicion(index),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _construirItemDato(
                      loc.weight,
                      '${medicion.peso.toStringAsFixed(1)} kg',
                      Icons.monitor_weight_outlined,
                    ),
                  ),
                  Expanded(
                    child: _construirItemDato(
                      loc.height,
                      '${medicion.altura.toStringAsFixed(2)} m',
                      Icons.height,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: color, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'IMC: ${medicion.imc.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        nombreCategoria,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirItemDato(String label, String valor, IconData icono) {
    return Row(
      children: [
        Icon(icono, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            Text(
              valor,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  void _mostrarDetallesMedicion(MedicionIMC medicion, AppLocalizations loc) {
    final color = _obtenerColorCategoria(medicion.categoria);
    final nombreCategoria = _obtenerNombreCategoria(medicion.categoria, loc);
    final formato = DateFormat('EEEE, dd MMMM yyyy - HH:mm', 'es');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  loc.measurementDetails,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  formato.format(medicion.fecha),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Divider(height: 32),
                Text(
                  medicion.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.2),
                        color.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'IMC',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        medicion.imc.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nombreCategoria,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _construirTarjetaDetalle(
                        loc.weight,
                        '${medicion.peso.toStringAsFixed(1)} kg',
                        Icons.monitor_weight,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _construirTarjetaDetalle(
                        loc.height,
                        '${medicion.altura.toStringAsFixed(2)} m',
                        Icons.height,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                if (medicion.edad != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _construirTarjetaDetalle(
                          loc.age,
                          '${medicion.edad} ${loc.years}',
                          Icons.cake,
                          Colors.orange,
                        ),
                      ),
                      if (medicion.sexo != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _construirTarjetaDetalle(
                            loc.sex,
                            medicion.sexo == Sexo.hombre
                                ? loc.male
                                : loc.female,
                            medicion.sexo == Sexo.hombre
                                ? Icons.male
                                : Icons.female,
                            medicion.sexo == Sexo.hombre
                                ? Colors.blue
                                : Colors.pink,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: Text(loc.close),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirTarjetaDetalle(
    String label,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
