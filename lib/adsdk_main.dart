import 'package:adsdk/src/adsdk/adsdk_appopen_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_banner_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_interstitial_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_lifecycle_reactor.dart';
import 'package:adsdk/src/adsdk/adsdk_native_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_rewarded_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_rewarded_interstitial_ad.dart';
import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/models/ad_sdk_ad.dart';
import 'package:adsdk/src/internal/models/ad_sdk_configuration.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/services/api_service.dart';
import 'package:adsdk/src/internal/services/local_storage_service.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:adsdk/src/internal/widgets/hardstop_dialog.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'src/admob/gdpr_constent_form.dart';

class AdSdk {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  static AppLifecycleReactor? appLifecycleReactor;
  static final admobConsent = AdmobConsentForm();

  static Future<void> initialize({
    required String bundleId,
    required String platform,
    required String configPath,
    required AdSdkConfiguration adSdkConfig,
    String? applovinSdkKey,
    Function(bool)? isHardStopEnabled,
  }) async {
    await LocalStorage.init();

    AdSdkState.adSdkConfig = adSdkConfig;

    final resp = await LocalStorage.getApiResponse(configPath);
    ApiService.fetchAds(packageId: bundleId, platform: platform);

    if (resp == null) return;

    isHardStopEnabled?.call(resp.app.enablePopup);

    if (!resp.app.showAppAds) {
      AdSdkLogger.error("Ads disabled from backend.");
      return;
    }

    AdSdkState.apiResp = resp;

    for (AdSdkAdConfig ad in resp.app.ads) {
      AdSdkState.ads[ad.adName] = ad;
    }

    if (adSdkConfig.googleAdsTestDevices.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: AdSdkState.adSdkConfig.googleAdsTestDevices,
        ),
      );
    }

    await MobileAds.instance.initialize();
    await const MethodChannel("adsdk").invokeMethod("registerNativeAds");
    AdSdkLogger.info("Google ads initialized.");
    admobConsent.fetchConsentInfo();

    if (applovinSdkKey != null) {
      if (adSdkConfig.applovinTestDevices.isNotEmpty) {
        AppLovinMAX.setTestDeviceAdvertisingIds(
          adSdkConfig.applovinTestDevices,
        );
      }
      AppLovinMAX.initialize(applovinSdkKey).then((value) {
        AdSdkLogger.info("Applovin initialized.");
      });
    }

    AdSdkLogger.info("AdSdk initialized.");

    _isInitialized = true;
  }

  static loadAd({
    required String adName,
    bool isDarkMode = false,
    required Function(List<String> errors) onAdFailedToLoad,
    required Function(AdSdkAd ad) onAdLoaded,
  }) {
    if (!_isInitialized) {
      return onAdFailedToLoad([AdSdkLogger.error("AdSdk not initialized.")]);
    }

    final adConfig = AdSdkState.ads[adName];

    if (adConfig == null) {
      return onAdFailedToLoad(
          [AdSdkLogger.error("Please provided correct adName.")]);
    }

    if (!adConfig.isActive) {
      return onAdFailedToLoad([AdSdkLogger.error("Ad '$adName' not active.")]);
    }

    AdSdkLogger.info("Loading ad - '$adName'");
    if (adConfig.adType == AdUnitType.interstitial) {
      AdSdkInterstitialAd.load(
        adConfig: adConfig,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    } else if (adConfig.adType == AdUnitType.appOpen) {
      AdSdkAppOpenAd.load(
        adConfig: adConfig,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    } else if (adConfig.adType == AdUnitType.rewarded) {
      AdSdkRewardedAd.load(
        adConfig: adConfig,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    } else if (adConfig.adType == AdUnitType.banner) {
      AdSdkBannerAd.load(
        adConfig: adConfig,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    } else if (adConfig.adType == AdUnitType.native) {
      AdSdkNativeAd.load(
        adConfig: adConfig,
        isDarkMode: isDarkMode,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    } else if (adConfig.adType == AdUnitType.rewardInterstitial) {
      AdSdkRewardedInterstitialAd.load(
        adConfig: adConfig,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdLoaded: onAdLoaded,
      );
    }
  }

  static void setAppOpenLifecycleReactor(String adName) {
    final config = AdSdkState.ads[adName];
    if (config == null) return;
    AdSdkLogger.info("Setting up AppOpenLifecycleReactor for ad $adName");
    appLifecycleReactor = AppLifecycleReactor(config: config);
    appLifecycleReactor!.listenToAppStateChanges();
  }

  static void removeAppOpenLifecycleReactor() {
    AdSdkLogger.info("Removing AppOpenLifecycleReactor");
    appLifecycleReactor?.removeAppStateListener();
  }

  static Future<bool> getConsentForEU() => admobConsent.show();

  static void showHardStopDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const HardstopDialog(),
      );
}
