import 'package:applovin_max/applovin_max.dart';

class ApplovinRewardedListenerHelper implements RewardedAdListener {
  ApplovinRewardedListenerHelper._() {
    _init();
  }

  static ApplovinRewardedListenerHelper? _instance;

  static ApplovinRewardedListenerHelper get instance =>
      _instance ??= ApplovinRewardedListenerHelper._();

  final List<CustomRewardedAdListener> _listeners = [];

  void addListener(CustomRewardedAdListener listener) {
    if (_listeners.contains(listener)) return;
    _listeners.add(listener);
  }

  void removeListener(CustomRewardedAdListener listener) {
    if (!_listeners.contains(listener)) return;
    _listeners.remove(listener);
  }

  void _init() => AppLovinMAX.setRewardedAdListener(this);

  @override
  Function(MaxAd ad) get onAdClickedCallback => (ad) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdClickedCallback(ad);
          }
        }
      };

  @override
  Function(MaxAd ad, MaxError error) get onAdDisplayFailedCallback =>
      (ad, error) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdDisplayFailedCallback(ad, error);
            removeListener(element);
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdDisplayedCallback => (ad) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdDisplayedCallback(ad);
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdHiddenCallback => (ad) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdHiddenCallback(ad);
          }
        }
      };

  @override
  Function(String adUnitId, MaxError error) get onAdLoadFailedCallback =>
      (adUnitId, error) {
        for (var element in _listeners) {
          if (element.adId == adUnitId) {
            element.onAdLoadFailedCallback(adUnitId, error);
            removeListener(element);
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdLoadedCallback => (ad) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdLoadedCallback(ad);
            removeListener(element);
          }
        }
      };

  @override
  Function(MaxAd ad, MaxReward reward) get onAdReceivedRewardCallback =>
      (ad, reward) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdReceivedRewardCallback(ad, reward);
            removeListener(element);
          }
        }
      };

  @override
  Function(MaxAd ad)? get onAdRevenuePaidCallback => (ad) {
        for (var element in _listeners) {
          if (element.adId == ad.adUnitId) {
            element.onAdRevenuePaidCallback?.call(ad);
          }
        }
      };
}

class CustomRewardedAdListener {
  final String adId;
  final Function(MaxAd ad) onAdClickedCallback;
  final Function(MaxAd ad, MaxError error) onAdDisplayFailedCallback;
  final Function(MaxAd ad) onAdDisplayedCallback;
  final Function(MaxAd ad) onAdHiddenCallback;
  final Function(String adUnitId, MaxError error) onAdLoadFailedCallback;
  final Function(MaxAd ad) onAdLoadedCallback;
  final Function(MaxAd ad, MaxReward reward) onAdReceivedRewardCallback;
  final Function(MaxAd ad)? onAdRevenuePaidCallback;

  CustomRewardedAdListener({
    required this.adId,
    required this.onAdClickedCallback,
    required this.onAdDisplayFailedCallback,
    required this.onAdDisplayedCallback,
    required this.onAdHiddenCallback,
    required this.onAdLoadFailedCallback,
    required this.onAdLoadedCallback,
    required this.onAdReceivedRewardCallback,
    required this.onAdRevenuePaidCallback,
  });
}
