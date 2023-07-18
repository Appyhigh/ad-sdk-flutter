import 'package:adsdk/src/internal/banner_ad/banner_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import '../../internal/enums/ad_size.dart';

class ApplovinBannerAd extends BannerAd {
  final AdSdkAdSize _sdkAdSize;

  ApplovinBannerAd(
    super.adId,
    this._sdkAdSize);


  bool _isAdLoaded = false;

  bool _failedToLoad = false;

  @override
  void dispose() {
    _isAdLoaded = false;
    _failedToLoad = false;
    AppLovinMAX.hideBanner(adId);
    AppLovinMAX.destroyBanner(adId);
  }

  void _attachAdListeners(AdLoadListener adLoadListener) {
    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      adLoadListener.onAdLoaded();
      _isAdLoaded=true;
      _failedToLoad=false;
      print('Banner ad loaded from ${ad.networkName}');
    }, onAdLoadFailedCallback: (adUnitId, error) {
      adLoadListener.onFailedToLoadAd();
      _isAdLoaded=false;
      _failedToLoad=true;
      print('Banner ad failed to load with error code ${error.code} and message: ${error.message}');
    }, onAdClickedCallback: (ad) {
      print('Banner ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('Banner ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('Banner ad collapsed');
    }, onAdRevenuePaidCallback: (ad) {
      print('Banner ad revenue paid: ${ad.revenue}');
    }));

  }

  @override
  Future<void> loadAd({required AdLoadListener adLoadListener}) async {
    _attachAdListeners(adLoadListener);
    AppLovinMAX.createBanner(adId, AdViewPosition.bottomCenter);
    AppLovinMAX.showBanner(adId);
  }

  @override
  AdProvider get provider => AdProvider.applovin;

  @override
  Widget build() => MaxAdView(
      adUnitId: adId,
      adFormat: AdFormat.banner,
      isAutoRefreshEnabled: true,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {
          _isAdLoaded=true;
          _failedToLoad=false;
          print('Banner widget ad loaded from ${ad.networkName}');
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _isAdLoaded=false;
          _failedToLoad=true;
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
    );

  @override
  bool get adFailedToLoad => _failedToLoad;

  @override
  double get height => 0;

  @override
  double get width => 0;

  @override
  bool get isAdLoaded => _isAdLoaded;
}
