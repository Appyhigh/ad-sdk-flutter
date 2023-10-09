import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

class ApplovinNativeAd extends StatefulWidget {
  const ApplovinNativeAd({
    super.key,
    required this.adUnitId,
    required this.backgroundColor,
    required this.textColor,
    required this.ctaColor,
    required this.adSize,
    required this.listener,
  });

  final String adUnitId;
  final int backgroundColor;
  final int textColor;
  final int ctaColor;
  final AdSdkAdSize adSize;
  final NativeAdListener listener;

  @override
  State<ApplovinNativeAd> createState() => _ApplovinNativeAdState();
}

class _ApplovinNativeAdState extends State<ApplovinNativeAd> {
  static const double _kMediaViewAspectRatio = 16 / 9;

  final double _mediaViewAspectRatio = _kMediaViewAspectRatio;

  final _nativeAdViewController = MaxNativeAdViewController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.adSize == AdSdkAdSize.mediumNative ? 300 : 120,
      child: MaxNativeAdView(
        adUnitId: widget.adUnitId,
        controller: _nativeAdViewController,
        listener: widget.listener,
        child: Container(
          color: Color(widget.backgroundColor),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: const MaxNativeAdIconView(
                      width: 48,
                      height: 48,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaxNativeAdTitleView(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(widget.textColor),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                        MaxNativeAdAdvertiserView(
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Color(widget.textColor),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        const MaxNativeAdStarRatingView(
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                  const MaxNativeAdOptionsView(
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
              if (widget.adSize == AdSdkAdSize.mediumNative)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: MaxNativeAdBodyView(
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Color(widget.textColor),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (widget.adSize == AdSdkAdSize.mediumNative)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AspectRatio(
                      aspectRatio: _mediaViewAspectRatio,
                      child: const MaxNativeAdMediaView(),
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: MaxNativeAdCallToActionView(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(widget.ctaColor),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
