import 'package:adsdk/src/applovin/banner_ad/applovin_banner_listener.dart';
import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:adsdk/src/internal/banner_ad/banner_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:adsdk/src/internal/listeners/ad_show_listener.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import '../../internal/enums/ad_size.dart';

class ApplovinBannerAd extends BannerAd implements ApplovinListener {
  final AdSdkAdSize _sdkAdSize;

  ApplovinBannerAd(super.adId, this._sdkAdSize) {
    ApplovinBannerListener.instance.addListener(this);
  }

  late AdLoadListener _loadListener;

  bool _isAdLoaded = false;

  bool _failedToLoad = false;

  @override
  void dispose() {
    _isAdLoaded = false;
    _failedToLoad = false;
    AppLovinMAX.destroyBanner(adId);
    ApplovinBannerListener.instance.removeListener(this);
  }

  @override
  Future<void> loadAd({required AdLoadListener adLoadListener}) async {
    _loadListener = adLoadListener;
    AppLovinMAX.createBanner(adId, AdViewPosition.bottomCenter);
    AppLovinMAX.showBanner(adId);
  }

  @override
  Widget build() => SizedBox(
        height: height,
        width: width,
        child: MaxAdView(
          adUnitId: adId,
          adFormat: AdFormat.banner,
          isAutoRefreshEnabled: true,
          listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {
              _isAdLoaded = true;
              _failedToLoad = false;
              print('Banner widget ad loaded from ${ad.networkName}');
            },
            onAdLoadFailedCallback: (adUnitId, error) {
              _isAdLoaded = false;
              _failedToLoad = true;
              print(
                  'Banner widget ad failed to load with error code ${error.code} and message: ${error.message}');
            },
            onAdClickedCallback: (ad) {
              print('Banner widget ad clicked');
            },
            onAdExpandedCallback: (ad) {
              print('Banner widget ad expanded');
            },
            onAdCollapsedCallback: (ad) {
              print('Banner widget ad collapsed');
            },
            onAdRevenuePaidCallback: (ad) {
              print('Banner widget ad revenue paid: ${ad.revenue}');
            },
          ),
        ),
      );

  @override
  bool get adFailedToLoad => _failedToLoad;

  @override
  double get height => 55;

  @override
  double get width => 468;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  AdProvider get provider => AdProvider.applovin;

  @override
  String get applovinAdId => adId;
  
  @override
  void onAdLoaded() => _loadListener.onAdLoaded();

  @override
  void onFailedToLoadAd() => _loadListener.onFailedToLoadAd();

  @override
  void onAdClosed() {}

  @override
  void onAdFailedToShow() {}

  @override
  void onAdSuccess() {}
}
