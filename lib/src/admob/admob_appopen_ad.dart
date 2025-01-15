import 'dart:async';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobAppOpenAd {
  static Future<AdSdkRawAd<Ad>> load(String adUnitId) async {
    final c = Completer<AdSdkRawAd<Ad>>();
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: AdSdkState.adSdkConfig.adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => c.complete(AdSdkRawAd(ad: ad)),
        onAdFailedToLoad: (error) => c.complete(
          AdSdkRawAd(error: error.message),
        ),
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
    return c.future;
  }
}
