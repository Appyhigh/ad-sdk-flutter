import 'dart:developer';

import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/interstital_interface/interstitial_ad_interface.dart';
import 'package:adsdk/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdMobAdProvider implements InterstitialAdInterface {
  @override
  String get adProviderName => AdProvider.ADMOB.name.toLowerCase();

  @override
  Future<void> loadInterstitialAd(
      {required String adUnit,
      required String adProvider,
      required Function(InterstitialAd p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    InterstitialAd.load(
      adUnitId: adUnit,
      request: Utils.getAdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('InterstitialAd Loaded');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (adError) {
          onAdFailedToLoad(adError.toString());
        },
      ),
    );
  }
}
