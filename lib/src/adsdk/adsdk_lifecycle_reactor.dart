import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/models/api_response.dart';

class AppLifecycleReactor {
  final AdSdkAdConfig config;

   AdSdkAd? ad;
   AdProvider? adProvider;

  AppLifecycleReactor({required this.config});

  void listenToAppStateChanges() {
    AdSdkLogger.info("Background Threshold: ${config.backgroundThreshold}");
    _loadAppOpenAd();
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void removeAppStateListener() {
    AppStateEventNotifier.stopListening();
  }

  DateTime? start;

  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.background) {
      start = DateTime.now();
    }
    if (appState == AppState.foreground &&
        DateTime.now().difference(start!).inSeconds >=
            Duration(milliseconds: config.backgroundThreshold).inSeconds) {
      showAppOpenAd();
    }
  }

  void showAppOpenAd() {
    ad?.show(
      onAdDismissedFullScreenContent: (ad) {},
      onAdShowedFullScreenContent: (ad) {},
      onAdFailedToShowFullScreenContent: (ad, error) {},
    );
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AdSdk.loadAd(
      adName: config.adName,
      onAdFailedToLoad: (errors) {},
      onAdLoaded: (ad) {
        this.ad = ad;
        adProvider = AdProvider.admob;
      },
    );
  }
}
