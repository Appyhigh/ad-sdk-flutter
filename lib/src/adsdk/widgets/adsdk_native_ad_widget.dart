import 'dart:async';

import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/applovin/applovin_native_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import 'package:shimmer/shimmer.dart';

class AdSdkNativeAdWidget extends StatefulWidget {
  const AdSdkNativeAdWidget({
    super.key,
    required this.adName,
    this.isDarkMode = false,
    this.adSdkAd,
  });

  final String adName;
  final AdSdkAd? adSdkAd;
  final bool isDarkMode;

  @override
  State<AdSdkNativeAdWidget> createState() => _AdSdkNativeAdWidgetState();
}

class _AdSdkNativeAdWidgetState extends State<AdSdkNativeAdWidget> {
  AdSdkAdConfig? config;
  bool adLoaded = false;

  AdProvider? adProvider;

  google_ads.NativeAd? ad;
  google_ads.NativeAd? newAd;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ad = AdSdkState.ads[widget.adName];
      if (ad == null) {
        AdSdkLogger.error("Please provided correct adName.");
        return;
      }
      _updateState(() => config = ad);
      if (config?.primaryAdprovider == AdProvider.applovin) {
        adProvider = AdProvider.applovin;
        _updateState(() => adLoaded = true);
        return;
      }
      if (widget.adSdkAd != null) {
        _updateState(() {
          this.ad = widget.adSdkAd!.ad;
          adLoaded = true;
        });
        startAutoRefresh();
      } else if (config != null) {
        AdSdk.loadAd(
          adName: config!.adName,
          isDarkMode: widget.isDarkMode,
          onAdFailedToLoad: (errors) {
            AdSdkLogger.info("Here");
            AdSdkLogger.error(
              "Failed to load ad - '${config!.adName}' with errors - $errors",
            );
            _updateState(() => adLoaded = false);
            if (config?.secondaryAdprovider == AdProvider.applovin) {
              adProvider = AdProvider.applovin;
              _updateState(() => adLoaded = true);
              return;
            }
          },
          onAdLoaded: (ad) {
            AdSdkLogger.info("Here: ${ad.toString()}");
            _updateState(() => adLoaded = false);
            _updateState(() {
              this.ad = ad.ad;
              adLoaded = true;
            });
            loadAd();
            startAutoRefresh();
          },
        );
      }
    });
  }

  void _updateState(Function callback) async {
    await callback();
    if (mounted) setState(() {});
  }

  void startAutoRefresh() {
    if (config == null) return;
    AdSdkLogger.info("Starting auto refresh for ad: ${config!.adName}");
    loadAd();
    _timer = Timer.periodic(
      Duration(milliseconds: config!.refreshRateMs),
          (_) {
        if (newAd != null) {
          _updateState(() => adLoaded = false);
          Future.delayed(
            const Duration(seconds: 1),
                () {
              _updateState(() => ad = newAd!);
              _updateState(() => adLoaded = true);
            },
          );
        }
        loadAd();
      },
    );
  }

  void loadAd() {
    if (config == null) return;
    AdSdk.loadAd(
      adName: config!.adName,
      isDarkMode: widget.isDarkMode,
      onAdFailedToLoad: (errors) {
        AdSdkLogger.error(
          "Failed to load ad - '${config!.adName}' with errors - $errors",
        );
        if (config?.secondaryAdprovider == AdProvider.applovin) {
          adProvider = AdProvider.applovin;
          _updateState(() => adLoaded = true);
          return;
        }
      },
      onAdLoaded: (ad) {
        AdSdkLogger.info("New Ad Loaded: ${ad.toString()}");
        _updateState(() => newAd = ad.ad);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.adSdkAd?.dispose();
    ad?.dispose();
    newAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (config == null || (ad == null && adProvider != AdProvider.applovin)) {
      return const SizedBox();
    }
    if (!config!.isActive) return const SizedBox();
    if (!adLoaded) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.grey.withOpacity(0.6),
        period: const Duration(seconds: 1),
        child: Container(
          height: config!.size.nativeAdHeight,
          width: double.maxFinite,
          decoration: const BoxDecoration(color: Colors.grey),
        ),
      );
    }
    return adProvider == AdProvider.applovin
        ? ApplovinNativeAd(
      listener: NativeAdListener(
        onAdClickedCallback: (ad) {
          AdSdkLogger.info("onAdClickedCallback: ${ad.toString()}");
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          AdSdkLogger.error(
            "onAdLoadFailedCallback - '$adUnitId' with error - $error",
          );
          if (config?.secondaryAdprovider == AdProvider.admob) {
            loadAd();
          }
        },
        onAdLoadedCallback: (ad) {
          AdSdkLogger.info("onAdLoadedCallback: ${ad.toString()}");
        },
      ),
      adSize: config!.size,
      adUnitId: config?.primaryAdprovider == AdProvider.applovin
          ? config!.primaryIds.first
          : config!.secondaryIds.first,
      backgroundColor: int.parse(
        widget.isDarkMode
            ? config!.bgColorDark.replaceFirst("#", "0xFF")
            : config!.bgColor.replaceFirst("#", "0xFF"),
      ),
      textColor: int.parse(
        widget.isDarkMode
            ? config!.textColorDark.replaceFirst("#", "0xFF")
            : config!.textColor.replaceFirst("#", "0xFF"),
      ),
      ctaColor: int.parse(
        widget.isDarkMode
            ? config!.colorHexDark.replaceFirst("#", "0xFF")
            : config!.colorHex.replaceFirst("#", "0xFF"),
      ),
    )
        : Container(
      height: config!.size.nativeAdHeight,
      decoration: BoxDecoration(
        color: Color(
          int.parse(
            widget.isDarkMode
                ? config!.bgColorDark.replaceFirst("#", "0xFF")
                : config!.bgColor.replaceFirst("#", "0xFF"),
          ),
        ),
      ),
      child: google_ads.AdWidget(ad: ad!),
    );
  }
}
