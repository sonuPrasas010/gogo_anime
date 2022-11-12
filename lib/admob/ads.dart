// import 'dart:io';

// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';


// InterstitialAd? interstitialAd;
// int interstitialLoadCount = 0;
// void loadAdmobIntAd() {
//   InterstitialAd.load(
//       adUnitId: /*'ca-app-pub-7282495026623737/6709626114'*/
//           Platform.isAndroid
//               ? 'ca-app-pub-3940256099942544/1033173712'
//               : 'ca-app-pub-3940256099942544/4411468910',
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           print('$ad loaded');
//           interstitialAd = ad;

//           interstitialAd!.setImmersiveMode(true);
//           interstitialLoadCount = 0;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('InterstitialAd failed to load: $error.');
//           if (interstitialLoadCount++ > 10) return;
//           loadAdmobIntAd();
//         },
//       ));
// }

// void showAdmobInterstitialAd() async{
//   if (interstitialAd == null) {
//     print('Warning: attempt to show interstitial before loaded.');
//     return;
//   }

//   interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//     onAdShowedFullScreenContent: (InterstitialAd ad) =>
//         print('ad onAdShowedFullScreenContent.'),
//     onAdDismissedFullScreenContent: (InterstitialAd ad) {
//       print('$ad onAdDismissedFullScreenContent.');
//       ad.dispose();
//        interstitialAd!.dispose();
//       Future.delayed(const Duration(minutes: 5), loadAdmobIntAd);
//     },
//     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//       print('$ad onAdFailedToShowFullScreenContent: $error');
//       ad.dispose();
//       loadAdmobIntAd();
//     },
//   );
//   await interstitialAd!.show();
//   interstitialAd = null;
// }
