import 'dart:developer';

import 'package:unity_mediation/unity_mediation.dart';

class UnityAds {
  static bool isAdLoaded = false;

  static initialize() {
    UnityMediation.initialize(
      gameId: '4960247',
      onComplete: () {
        log('Initialization Complete');
        loadAd();
      },
      onFailed: (error, message) =>
          log('Initialization Failed: $error $message'),
    );
  }

  static void loadAd() {
    UnityMediation.loadInterstitialAd(
      adUnitId: 'Interstitial_Android',
      onComplete: (adUnitId) {
        isAdLoaded = true;
        log('Interstitial Ad Load Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) {
        isAdLoaded = false;

        Future.delayed(const Duration(seconds: 30), loadAd);

        log('Interstitial Ad Load Failed $adUnitId: $error $message');
      },
    );
  }

  static void showAd() {
    log("showing ad");
    if (!isAdLoaded) return;
    UnityMediation.showInterstitialAd(
      adUnitId: 'Interstitial_Android',
      onStart: (adUnitId) => log('Interstitial Ad $adUnitId started'),
      onClick: (adUnitId) => log('Interstitial Ad $adUnitId click'),
      onClosed: (adUnitId) {
        isAdLoaded = false;
        Future.delayed(const Duration(minutes: 5), loadAd);
      },
      onFailed: (adUnitId, error, message) =>
          log('Interstitial Ad $adUnitId failed: $error $message'),
    );
  }

  static loadRewardedAds() async {
    await UnityMediation.loadRewardedAd(
        adUnitId: "Rewarded_Android",
        onComplete: (_) async {
          // result = 1;
          log("Rewarded ad loaded");
        },
        onFailed: (adUnitId, error, errorMessage) {
          log("Error $error error message $errorMessage");
        });
    ;
  }

  static showRewardedAd() async {
    await UnityMediation.showRewardedAd(
      adUnitId: "Rewarded_Android",
      onRewarded: (adUnitId, reward) {
        log("rewarded: ${reward.type} ${reward.amount}");
      },
      onFailed: (adUnitId, error, errorMessage) {
        log("Failed to reward with error: $error with message: $errorMessage");
      },
    );
  }
}
