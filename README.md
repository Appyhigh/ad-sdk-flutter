# Ad Sdk Flutter

Easily integrate ads from different ad networks into your flutter app.

## Features

- Google Mobile Ads (banner, appOpen, interstitial, rewarded ad, rewarded interstitial, native ad)
- AppLovin Max Ads (banner, appOpen, interstitial, rewarded ad)

## Applovin Mediation
- This plugin supports applovin mediation [See Details](https://dash.applovin.com/documentation/mediation/flutter/mediation-adapters) to see Applovin Mediation Guide.
- You just need to add the naative platform setting for applovin mediation.

## Platform Specific Setup

### iOS

#### Update your Info.plist

* The key for Google Ads **is required** in Info.plist.

Update your app's `ios/Runner/Info.plist` file to add the key:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_SDK_KEY</string>
```

* You have to add `SKAdNetworkItems` for all networks provided by ad-sdk-flutter [info.plist](/example/ios/Runner/Info.plist) you can copy paste `SKAdNetworkItems` in  your own project.

### Android

#### Update AndroidManifest.xml

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

## Initialize Ad Names

You will receive all ad names from your app, which are available in the [Dashboard](https://admobdash-v2.apyhi.com/app-list).

```dart
class AdNames {
  static const String appOpen = "app_open";
  static const String intertitialAd = "intertitial_ad";
  static const String rewardedAd = "rewarded_ad";
  static const String bannerAd = "banner_ad";
  static const String nativeAd = "native_ad";
}
```

## Initialize Ad Sdk

Before loading ads, have your app initialize the Ads SDK by calling `AdSdk.initialize()` which initializes the SDK and returns a `Future` that finishes once initialization is complete. This needs to be done only once, ideally right before running the app.

```dart
AdSdk.initialize(
    // Specified in the AdSdk dashboard.
    bundleId: "<BUNDLE_ID>",
    // Specified in the AdSdk dashboard.
    platform: "<YOUR_PLATFORM>",
    // Local path to the AdSdk config file e.g /assets/json/app_name.json.
    configPath: "<CONFIG_FILE_PATH>",
    adSdkConfig: AdSdkConfiguration(
        // To enable Applovin Max Test Ads
        isTestMode: true,
        // Custom Admob Ad Request
        adRequest: AdRequest(),
        // Custom AdManager Ad Request
        adManagerAdRequest: AdManagerAdRequest(),
        // Applovin Max Test Devices
        applovinTestDevices: [
            '072D2F3992EF5B4493042ADC632CE39F', // Mi Phone
        ],
        // Google Ads Test Devices
        googleAdsTestDevices: [],
    ),
    applovinSdkKey: "YOUR_SDK_KEY",
);
```
## EU Consent (GDPR)

Requests showing of a native Consent Form for user.
Form consists of Consent Message and buttons:
[Consent], [Do not consent]

If [isTestMode] equals `true`
then you need to specify [testIdentifier].
You can find it in logs.

Function returns `true` if
Consent Form loaded (but not required to be shown)
ConsentStatuses for `true`:
`REQUIRED`, `OBTAINED` or `NOT_REQUIRED`.

Returns `false` because of
error during loading of Consent Form.
Error will occurs if in test mode you are not specified [testDeviceId]

  
```dart
final result = await AdSdk.getConsentForEU(
    isTestMode: false,
    testIdentifier: '<DEVICE_ID>',
)
```

## Load Ads

AdSdk provides a single method to load ads. 

```dart
AdSdk.loadAd(
    adName: "<AD_NAME>" // AdNames.appOpen,
    isDarkMode = false // For Native Ads,
    onAdFailedToLoad: (errors) {
            // Handle Errors
    },
    onAdLoaded: (ad) {
        // ad is an AdSdkAd object which needs to be stored in order to show the ad
    },
)
```
## Show Ads

You can show ads using the loaded `ad` object. 

```dart
AdSdkAd? appOpenAd;

// Load the ad
AdSdk.loadAd(
    adName: AdNames.appOpen,
    isDarkMode = false,
    onAdFailedToLoad: (errors) {},
    onAdLoaded: (ad) {
        appOpenAd = ad;
    },
)

// Show the ad
appOpenAd?.show(
    // Triggers when ad is dismissed.
    onAdDismissedFullScreenContent: (ad) {
        // You can perform any action here when ad is dismissed
    },
    // Triggers when ad is showing on screen.
    onAdShowedFullScreenContent: (ad) {
        // You can perform any action here when ad is showing on screen
    },
    // Triggers when ad failed to show.
    onAdFailedToShowFullScreenContent: (ad, error) {
        // Handle Errors
        // You can also try to load the ad again here
    },
    // Triggers only when a user earned a reward on a rewarded ad.
    onUserEarnedReward: (amount, type) {
        // You can give reward to user here
    },
);
```

## Show Banner Ads

This is how you may show banner ad in widget-tree somewhere:
```dart
@override
Widget build(BuildContext context) {
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SomeWidget(),
      const Spacer(),
      AdSdkBannerAdWidget(
          adName: AdNames.bannerAd,
      ),
    ],
  );
}
```

## Show Native Ads

This is how you may show native ad in widget-tree somewhere:
```dart
@override
Widget build(BuildContext context) {
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SomeWidget(),
      const Spacer(),
      AdSdkNativeAdWidget(
          adName: AdNames.bannerAd,
          // For Dark Mode
          isDarkMode: false,
      ),
    ],
  );
}
```

### Preloading Native Ads

You can load native ads in advance and show them when needed. This is how you may preload native ad:
```dart
AdSdkAd? nativeAd;

// Load the ad
AdSdk.loadAd(
    adName: AdNames.nativeAd,
    isDarkMode = false,
    onAdFailedToLoad: (errors) {},
    onAdLoaded: (ad) {
        nativeAd = ad;
    },
)

// Show the ad
AdSdkNativeAdWidget(
    adName: AdNames.nativeAd,
    // Pass the preloaded ad here
    ad: nativeAd,
    // For Dark Mode
    isDarkMode: false,
),
```

## Show BG to FG Ads

AdSdk providers a method to set and remove the AppOpenLifecycleReactor which is used to show BG to FG ads.

```dart
// Set the AppOpenLifecycleReactor
AdSdk.setAppOpenLifecycleReactor(
    AdNames.appOpen, // Ad Name
);

// Remove the AppOpenLifecycleReactor
AdSdk.removeAppOpenLifecycleReactor();
```

## Ad Manager

In order to manage ads, you can use the `AdManager` class. It provides methods to load and show ads. 

```dart
import 'dart:async';

import 'package:adsdk/adsdk.dart';
import 'ad_names.dart';
import 'package:flutter/foundation.dart';

class AdManager {
  // Store the loaded ads
  static final Map<String, AdSdkAd?> _appAds = {};

  // Get the loaded ad (can be used to get the preloaded ad for a native ad).
  AdSdkAd? getAd(String adName) {
    return _appAds[adName];
  }

  // Initialize the AdSdk
  Future<bool> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    try {
        AdSdk.initialize(
            bundleId: "<BUNDLE_ID>",
            platform: "<YOUR_PLATFORM>",
            configPath: "<CONFIG_FILE_PATH>",
            adSdkConfig: AdSdkConfiguration(
                isTestMode: kDebugMode,
            ),
            applovinSdkKey: "YOUR_SDK_KEY",
        );
      return AdSdk.isInitialized;
    } catch (e) {
      return false;
    }
  }

  // Load the ad
  Future<bool> loadAd(String adName) async {
    try {
      final c = Completer<bool>();
      AdSdk.loadAd(
        adName: adName,
        onAdFailedToLoad: (errors) {
          c.complete(false);
        },
        onAdLoaded: (ad) {
          _appAds[adName] = ad;
          c.complete(true);
        },
      );
      return c.future;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Show the ad
  void showAd(
    String adName, {
    Function(AdSdkAd? ad)? onAdDismissedFullScreenContent,
    Function(AdSdkAd? ad)? onAdShowedFullScreenContent,
    Function(AdSdkAd? ad, String? error)? onAdFailedToShowFullScreenContent,
    Function(num amount, String type)? onUserEarnedReward,
  }) async {
    try {
      if (_appAds[adName] == null) {
        onAdFailedToShowFullScreenContent?.call(null, null);
        loadAd(adName);
      } else {
        _appAds[adName]?.show(
          onAdDismissedFullScreenContent: (ad) {
            onAdDismissedFullScreenContent?.call(ad);
            loadAd(adName);
          },
          onAdShowedFullScreenContent: onAdShowedFullScreenContent,
          onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent,
          onUserEarnedReward: onUserEarnedReward,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // Set BG to FG Ad
  void setAppOpenAd() {
    AdSdk.setAppOpenLifecycleReactor(AdNames.bgToFgAppOpen);
  }

  // Remove BG to FG Ad
  void removeAppOpenAd() {
    AdSdk.removeAppOpenLifecycleReactor();
  }
}
```