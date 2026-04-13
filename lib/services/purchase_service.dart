import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// Servicio para manejar las compras dentro de la aplicación (IAP)
/// En modo desarrollo (devMode = true), simula que el usuario tiene premium
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String _purchaseKey = 'has_purchased_peso_ideal';

  bool _hasPurchased = false;
  bool get hasPurchased {
    // En modo desarrollo, siempre retorna true para probar
    if (devMode) return true;
    return _hasPurchased;
  }

  ProductDetails? _productDetails;
  ProductDetails? get productDetails => _productDetails;

  /// Inicializa el servicio de compras
  Future<void> initialize() async {
    // En modo desarrollo, marcar como comprado y salir
    if (devMode) {
      _hasPurchased = true;
      if (kDebugMode) {
        print('🔓 devMode: Premium desbloqueado automáticamente');
      }
      return;
    }

    // Cargar estado de compra guardado
    final prefs = await SharedPreferences.getInstance();
    _hasPurchased = prefs.getBool(_purchaseKey) ?? false;

    // Verificar disponibilidad de IAP
    final available = await _iap.isAvailable();
    if (!available) {
      if (kDebugMode) {
        print('❌ IAP no disponible en este dispositivo');
      }
      return;
    }

    // Cargar detalles del producto
    const Set<String> ids = {productIdPremium};
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (response.productDetails.isNotEmpty) {
      _productDetails = response.productDetails.first;
      if (kDebugMode) {
        print(
          '✅ Producto cargado: ${_productDetails!.title} - ${_productDetails!.price}',
        );
      }
    } else {
      if (kDebugMode) {
        print('⚠️ Producto no encontrado en Google Play');
      }
    }

    // Escuchar cambios de compra
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        if (kDebugMode) {
          print('❌ Error en purchase stream: $error');
        }
      },
    );

    // Restaurar compras pendientes
    await _iap.restorePurchases();
  }

  /// Maneja actualizaciones del estado de compra
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _savePurchase();
        _hasPurchased = true;
        if (kDebugMode) {
          print('✅ Compra exitosa o restaurada');
        }
      } else if (purchase.status == PurchaseStatus.error) {
        if (kDebugMode) {
          print('❌ Error en compra: ${purchase.error}');
        }
      } else if (purchase.status == PurchaseStatus.pending) {
        if (kDebugMode) {
          print('⏳ Compra pendiente...');
        }
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Guarda el estado de compra localmente
  Future<void> _savePurchase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_purchaseKey, true);
  }

  /// Inicia el proceso de compra del producto premium
  Future<bool> buyProduct() async {
    if (devMode) {
      if (kDebugMode) {
        print('🔓 devMode: Simulando compra exitosa');
      }
      _hasPurchased = true;
      return true;
    }

    if (_productDetails == null) {
      if (kDebugMode) {
        print('❌ No hay detalles del producto disponibles');
      }
      return false;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _productDetails!,
    );

    try {
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al iniciar compra: $e');
      }
      return false;
    }
  }

  /// Restaura compras anteriores del usuario
  Future<void> restorePurchases() async {
    if (devMode) {
      if (kDebugMode) {
        print('🔓 devMode: Premium ya desbloqueado');
      }
      return;
    }

    try {
      await _iap.restorePurchases();
      if (kDebugMode) {
        print('🔄 Restaurando compras...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al restaurar compras: $e');
      }
    }
  }

  /// Limpia los recursos al cerrar
  void dispose() {
    _subscription?.cancel();
  }
}
