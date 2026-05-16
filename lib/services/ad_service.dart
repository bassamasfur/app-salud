import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Servicio centralizado para manejar anuncios de AdMob
/// Gestiona la carga, visualización y ciclo de vida de los anuncios
class AdService {
  // IDs de AdMob - PRODUCCIÓN
  static String get _appId => Platform.isAndroid
      ? 'ca-app-pub-9670246345724768~5207969265'
      : 'ca-app-pub-9670246345724768~5207969265'; // Usar el mismo para ambos por ahora

  static String get _bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-9670246345724768/1514731298'
      : 'ca-app-pub-9670246345724768/1514731298'; // Usar el mismo para ambos

  // IDs de prueba de Google (descomentar para testing)
  // static String get _bannerAdUnitId => Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/6300978111' // Test ID Android
  //     : 'ca-app-pub-3940256099942544/2934735716'; // Test ID iOS

  /// Obtiene el ID del banner
  static String get bannerAdUnitId => _bannerAdUnitId;

  /// Obtiene el ID de la app
  static String get appId => _appId;

  /// Inicializa el SDK de MobileAds
  /// Debe llamarse una vez al iniciar la app
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      debugPrint('✅ AdMob inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar AdMob: $e');
    }
  }

  /// Crea y carga un BannerAd
  /// Retorna null si falla la creación
  static BannerAd? createBannerAd({
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    try {
      final banner = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner, // 320x50
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('✅ Banner cargado correctamente');
            onAdLoaded(ad);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('❌ Error al cargar banner: ${error.message}');
            ad.dispose();
            onAdFailedToLoad(ad, error);
          },
          onAdOpened: (ad) {
            debugPrint('📱 Banner abierto');
          },
          onAdClosed: (ad) {
            debugPrint('🔒 Banner cerrado');
          },
        ),
      );

      // Cargar el anuncio
      banner.load();
      return banner;
    } catch (e) {
      debugPrint('❌ Error al crear banner: $e');
      return null;
    }
  }

  /// Crea un banner con tamaño adaptativo
  /// Mejor para diferentes tamaños de pantalla
  static Future<BannerAd?> createAdaptiveBannerAd({
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
    required double maxWidth,
  }) async {
    try {
      final adaptiveSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            maxWidth.toInt(),
          );

      if (adaptiveSize == null) {
        debugPrint('❌ No se pudo obtener tamaño adaptativo');
        return null;
      }

      final banner = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: adaptiveSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint(
              '✅ Banner adaptativo cargado: ${adaptiveSize.width}x${adaptiveSize.height}',
            );
            onAdLoaded(ad);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('❌ Error al cargar banner adaptativo: ${error.message}');
            ad.dispose();
            onAdFailedToLoad(ad, error);
          },
        ),
      );

      banner.load();
      return banner;
    } catch (e) {
      debugPrint('❌ Error al crear banner adaptativo: $e');
      return null;
    }
  }

  /// Dispone correctamente de un anuncio
  static void disposeBanner(BannerAd? banner) {
    if (banner != null) {
      banner.dispose();
      debugPrint('🗑️ Banner eliminado');
    }
  }
}
