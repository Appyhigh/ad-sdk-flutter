import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';

class AdSdkAd {
  dynamic ad;

  String adName;
  String adUnitId;

  AdProvider adProvider;
  AdUnitType adUnitType;

  AdSdkAd({
    required this.ad,
    required this.adName,
    required this.adUnitId,
    required this.adProvider,
    required this.adUnitType,
  });

  AdSdkAd copyWith({
    dynamic ad,
    String? adName,
    String? adUnitId,
    AdProvider? adProvider,
    AdUnitType? adUnitType,
  }) {
    return AdSdkAd(
      ad: ad ?? this.ad,
      adName: adName ?? this.adName,
      adUnitId: adUnitId ?? this.adUnitId,
      adProvider: adProvider ?? this.adProvider,
      adUnitType: adUnitType ?? this.adUnitType,
    );
  }

  void show({
    Function(AdSdkAd ad)? onAdDismissedFullScreenContent,
    Function(AdSdkAd ad)? onAdShowedFullScreenContent,
    Function(AdSdkAd ad, String error)? onAdFailedToShowFullScreenContent,
    Function(num amount, String type)? onUserEarnedReward,
  }) {
    if (adProvider == AdProvider.admob || adProvider == AdProvider.admanager) {
      if (adUnitType == AdUnitType.appOpen) {
        (ad as AppOpenAd).fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) =>
              onAdDismissedFullScreenContent?.call(this),
          onAdShowedFullScreenContent: (_) =>
              onAdShowedFullScreenContent?.call(this),
          onAdFailedToShowFullScreenContent: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
        );
        (ad as AppOpenAd).show();
      } else if (adUnitType == AdUnitType.rewardInterstitial) {
        (ad as RewardedInterstitialAd).fullScreenContentCallback =
            FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) =>
              onAdDismissedFullScreenContent?.call(this),
          onAdShowedFullScreenContent: (_) =>
              onAdShowedFullScreenContent?.call(this),
          onAdFailedToShowFullScreenContent: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
        );
        (ad as RewardedInterstitialAd).show(
            onUserEarnedReward: (ad, reward) =>
                onUserEarnedReward?.call(reward.amount, reward.type));
      } else if (adUnitType == AdUnitType.interstitial) {
        if (adProvider == AdProvider.admob) {
          (ad as InterstitialAd).fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) =>
                onAdDismissedFullScreenContent?.call(this),
            onAdShowedFullScreenContent: (_) =>
                onAdShowedFullScreenContent?.call(this),
            onAdFailedToShowFullScreenContent: (ad, error) =>
                onAdFailedToShowFullScreenContent?.call(this, error.message),
          );
          (ad as InterstitialAd).show();
        } else {
          (ad as AdManagerInterstitialAd).fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) =>
                onAdDismissedFullScreenContent?.call(this),
            onAdShowedFullScreenContent: (_) =>
                onAdShowedFullScreenContent?.call(this),
            onAdFailedToShowFullScreenContent: (ad, error) =>
                onAdFailedToShowFullScreenContent?.call(this, error.message),
          );
          (ad as AdManagerInterstitialAd).show();
        }
      } else if (adUnitType == AdUnitType.rewarded) {
        (ad as RewardedAd).fullScreenContentCallback =
            FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) =>
              onAdDismissedFullScreenContent?.call(this),
          onAdShowedFullScreenContent: (_) =>
              onAdShowedFullScreenContent?.call(this),
          onAdFailedToShowFullScreenContent: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
        );
        (ad as RewardedAd).show(
            onUserEarnedReward: (ad, reward) =>
                onUserEarnedReward?.call(reward.amount, reward.type));
      }
    } else if (adProvider == AdProvider.applovin) {
      if (adUnitType == AdUnitType.appOpen) {
        AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent?.call(this),
          onAdDisplayFailedCallback: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent?.call(this),
        ));
        AppLovinMAX.showAppOpenAd(adUnitId);
      } else if (adUnitType == AdUnitType.interstitial) {
        AppLovinMAX.setInterstitialListener(InterstitialListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent?.call(this),
          onAdDisplayFailedCallback: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent?.call(this),
        ));
        AppLovinMAX.showInterstitial(adUnitId);
      } else if (adUnitType == AdUnitType.rewarded ||
          adUnitType == AdUnitType.rewardInterstitial) {
        AppLovinMAX.setRewardedAdListener(RewardedAdListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent?.call(this),
          onAdDisplayFailedCallback: (ad, error) =>
              onAdFailedToShowFullScreenContent?.call(this, error.message),
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent?.call(this),
          onAdReceivedRewardCallback: (ad, reward) {
            if (onUserEarnedReward != null) {
              onUserEarnedReward(reward.amount, reward.label);
            }
          },
        ));
        AppLovinMAX.showRewardedAd(adUnitId);
      }
    }
  }

  void dispose() {
    if (adProvider == AdProvider.admob || adProvider == AdProvider.admob) {
      ad.dispose();
    }
  }
}
