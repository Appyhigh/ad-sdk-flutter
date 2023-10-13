import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdSdkAdSize {
  banner("banner"),
  largeBanner("large_banner"),
  mediumBanner("medium_rectangle"),
  smallNative("small"),
  mediumNative("medium");

  final String key;

  const AdSdkAdSize(this.key);
}

extension AdSdkAdSizeStringExtension on String {
  AdSdkAdSize get adSdkAdSize {
    if (toLowerCase() == AdSdkAdSize.largeBanner.key.toLowerCase()) {
      return AdSdkAdSize.largeBanner;
    } else if (toLowerCase() == AdSdkAdSize.mediumBanner.key.toLowerCase()) {
      return AdSdkAdSize.mediumBanner;
    } else if (toLowerCase() == AdSdkAdSize.smallNative.key.toLowerCase()) {
      return AdSdkAdSize.smallNative;
    } else if (toLowerCase() == AdSdkAdSize.mediumNative.key.toLowerCase()) {
      return AdSdkAdSize.mediumNative;
    }
    return AdSdkAdSize.banner;
  }
}

extension AdSdkAdSizeExtension on AdSdkAdSize {
  AdSize get admobSize {
    switch (this) {
      case AdSdkAdSize.largeBanner:
        return AdSize.largeBanner;
      case AdSdkAdSize.mediumBanner:
        return AdSize.mediumRectangle;
      default:
        return AdSize.banner;
    }
  }

  AdFormat get applovinSize {
    switch (this) {
      case AdSdkAdSize.mediumBanner:
        return AdFormat.mrec;
      default:
        return AdFormat.banner;
    }
  }

  String get factoryId {
    switch (this) {
      case AdSdkAdSize.mediumNative:
        return "mediumNativeAdView";
      case AdSdkAdSize.smallNative:
        return "smallNativeAdView";
      default:
        return "nativeAdView";
    }
  }

  double get nativeAdHeight {
    switch (this) {
      case AdSdkAdSize.mediumNative:
        return Platform.isAndroid ? 270 : 300;
      case AdSdkAdSize.smallNative:
        return 72;
      default:
        return Platform.isAndroid ? 110 : 80;
    }
  }
}
