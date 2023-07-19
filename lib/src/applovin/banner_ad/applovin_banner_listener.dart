import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';


class ApplovinBannerListener implements AdViewAdListener{

  final List<ApplovinListener> _listeners = [];

  void addListener(ApplovinListener applovinListener) {
    _listeners.add(applovinListener);
  }

  void removeListener(ApplovinListener applovinListener) {
    _listeners.remove(applovinListener);
  }

  static ApplovinBannerListener? _instance;

  static ApplovinBannerListener get instance =>
      _instance ??= ApplovinBannerListener._();

  ApplovinBannerListener._() {
    AppLovinMAX.setBannerListener(this);
  }

  @override
  Function(MaxAd ad) get onAdClickedCallback => (MaxAd ad) {};


  @override
  Function(String adUnitId, MaxError error) get onAdLoadFailedCallback =>
      (String adUnitId, MaxError error) {
        AdSdkLogger.info('Applovin $adUnitId onAdLoadFailedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == adUnitId) {
            element.onFailedToLoadAd();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdLoadedCallback => (MaxAd ad) {
        AdSdkLogger.info('Applovin ${ad.adUnitId} onAdLoadedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdLoaded();
          }
        }
      };

  @override
  Function(MaxAd ad)? get onAdRevenuePaidCallback => (MaxAd ad) {};

  @override
  // TODO: implement onAdCollapsedCallback
  Function(MaxAd ad) get onAdCollapsedCallback => throw UnimplementedError();

  @override
  // TODO: implement onAdExpandedCallback
  Function(MaxAd ad) get onAdExpandedCallback => throw UnimplementedError();

}