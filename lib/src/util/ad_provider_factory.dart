import 'package:adsdk/src/admanager/admanager_ads.dart';
import 'package:adsdk/src/admob/admob_ads.dart';
import 'package:adsdk/src/applovin/applovin_ads.dart';
import 'package:adsdk/src/applovin/banner_ad/applovin_banner_ad.dart';
import 'package:adsdk/src/applovin/native_ad/applovin_native_ad.dart';
import 'package:adsdk/src/internal/ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/models/ad_entity_config.dart';
import 'package:adsdk/src/internal/models/ad_sdk_configuration.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;

class AdProviderFactory {
  static Ad provideAd(String adId, AdProvider adProvider, AdEntityConfig adConfig,
      AdSdkConfiguration adSdkConfig) {
    AdUnitType adUnitType = adConfig.adType;
    AdSdkConfiguration adSdkConfiguration = adSdkConfig;
    switch (adProvider) {
      case AdProvider.admob:
        final adRequest = google_ads.AdRequest(
          nonPersonalizedAds: !adSdkConfiguration.personalisedAds,
          httpTimeoutMillis: adConfig.primaryAdLoadTimeoutMs,
        );
        switch (adUnitType) {
          case AdUnitType.appOpen:
            return AdmobAppOpenAd(adId, adRequest: adRequest);
          case AdUnitType.interstitial:
            return AdmobInterstitialAd(adId, adRequest: adRequest);
          case AdUnitType.rewarded:
            return AdmobRewardedAd(adId, adRequest: adRequest);
          case AdUnitType.rewardInterstitial:
            return AdmobRewardedInterstitialAd(adId, adRequest: adRequest);
          case AdUnitType.banner:
            return AdmobBannerAd(adId, adConfig.size, adRequest: adRequest);
          case AdUnitType.native:
            return AdmobNativeAd(adId, adConfig.size, adRequest: adRequest);
        }
      case AdProvider.admanager:
        final adRequest = google_ads.AdManagerAdRequest(
          nonPersonalizedAds: !adSdkConfiguration.personalisedAds,
          httpTimeoutMillis: adConfig.primaryAdLoadTimeoutMs,
        );
        switch (adUnitType) {
          case AdUnitType.interstitial:
            return AdManagerInterstitialAd(adId, adRequest: adRequest);
          default:
            throw Exception();
        }
      case AdProvider.applovin:
        switch (adUnitType) {
          case AdUnitType.interstitial:
            return ApplovinInterstitialAd(adId);
          case AdUnitType.appOpen:
            return ApplovinAppOpenAd(adId);
          case AdUnitType.rewarded:
            return ApplovinRewardedAd(adId);
          case AdUnitType.rewardInterstitial:
            return ApplovinRewardedAd(adId);
          case AdUnitType.native:
            return ApplovinNativeAd(adId, adConfig.size);
          case AdUnitType.banner:
            return ApplovinBannerAd(adId, adConfig.size);
          default:
            throw Exception();
        }
    }
  }
}
