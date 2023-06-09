import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/interstital_interface/interstitial_ad_interface.dart';
import 'package:applovin_max/applovin_max.dart';

class InterstitialAppLovinAdProvider implements InterstitialAdInterface {
  @override
  String get adProviderName => AdProvider.APPLOVIN.name.toLowerCase();

  @override
  Future<void> loadInterstitialAd(
      {required String adUnit,
      required String adProvider,
      required Function(MaxAd p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    Map? configuration = await AppLovinMAX.initialize(adUnit);
    if (configuration != null) {
      AppLovinMAX.loadInterstitial(adUnit);
      AppLovinMAX.setInterstitialListener(InterstitialListener(
          onAdLoadedCallback: (maxAd) {
            onAdLoaded(maxAd);
          },
          onAdLoadFailedCallback: (maxAd, maxError) {
            onAdFailedToLoad(maxError.toString());
          },
          onAdDisplayedCallback: (maxAd) {},
          onAdDisplayFailedCallback: (maxAd, maxError) {},
          onAdClickedCallback: (maxAd) {},
          onAdHiddenCallback: (maxAd) {}));
    }
  }
}
