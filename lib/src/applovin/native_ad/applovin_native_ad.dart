import 'package:flutter/material.dart';
import 'package:adsdk/src/internal/native_ad/native_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import '../../internal/enums/ad_size.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';

class ApplovinNativeAd extends NativeAd{
  final AdSdkAdSize _sdkAdSize;
  ApplovinNativeAd(
    super.adId,
    this._sdkAdSize,
  );

  bool _isAdLoaded = false;

  bool _failedToLoad = false;

  final MaxNativeAdViewController controller =
      MaxNativeAdViewController();

  MaxNativeAdView? _nativeAdViewRef;

  @override
  void dispose() {
    _isAdLoaded = false;
    _failedToLoad = false;
  }

  Size get _nativeSize {
    switch (_sdkAdSize) {
      case AdSdkAdSize.mediumNative:
        return const Size(468, 250);
      case AdSdkAdSize.smallNative:
        return const Size(468, 72);
      default:
        return const Size(468, 72);
    }
  }

  @override
  Future<void> loadAd({required AdLoadListener adLoadListener}) async {
    _nativeAdViewRef=MaxNativeAdView(
        height: height,
        width: width,
        controller: controller,
        adUnitId: adId,
        listener: NativeAdListener(onAdLoadedCallback: (ad) {
          print('AdCombo Native ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          print(
              'AdCombo Native ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          print('AdCombo Native ad clicked');
        }, onAdRevenuePaidCallback: (ad) {
          print('AdCombo Native ad revenue paid: ${ad.revenue}');
        }),
        child: Container(
          height: height,
          width: width,
          color: Color.fromARGB(255, 232, 224, 71),
          child: Row(
            children: [
              MaxNativeAdMediaView(
                width: 100,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MaxNativeAdTitleView(
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  MaxNativeAdAdvertiserView(
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  MaxNativeAdStarRatingView(
                    size: 10,
                  ),
                  MaxNativeAdBodyView(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaxNativeAdCallToActionView(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 11, 123, 151)),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      textStyle: MaterialStatePropertyAll(
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaxNativeAdIconView(
                        height: 20,
                        width: 20,
                      ),
                      MaxNativeAdOptionsView(
                        height: 20,
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
              
            ],
          ),
        ),
      );

    _nativeAdViewRef!.controller!.loadAd();
  }

  @override
  AdProvider get provider => AdProvider.applovin;

  @override
  Widget build() => SizedBox(
        height: height,
        width: width,
        child: _nativeAdViewRef
      );


  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  bool get adFailedToLoad => _failedToLoad;

  @override
  double get height => _nativeSize.height;

  @override
  double get width => _nativeSize.width;
}
