import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class FacebookAd {
  static bool isInterstitialAdLoaded = false;
  static void loadInterstitialAd() async {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "1490795468052198_1490795564718855",
      listener: (result, value) {
        // debugPrint("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.ERROR) {
          loadInterstitialAd();
          isInterstitialAdLoaded = false;
        }
        // FacebookInterstitialAd.showInterstitialAd(delay: 5000);
      },
    );
  }

  static void showInterstitialAd() async {
    debugPrint("showing");
    if (isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
      FacebookAudienceNetwork.destroyInterstitialAd().then((value) {
        if (value!) {
          debugPrint("destroyed ad");
          isInterstitialAdLoaded = false;
          Future.delayed(
            const Duration(minutes: 5),
          ).then(
            (value) => loadInterstitialAd(),
          );
          ;
        }
      });
    } else {
      debugPrint("Interstitial Ad not yet loaded!");
    }
  }
}
