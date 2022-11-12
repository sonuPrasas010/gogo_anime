import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_gogo_anime/admob/facebook_ads.dart';
import 'package:new_gogo_anime/admob/unity_ads.dart';
import 'categories.dart';

// var isInterstitialAdLoaded = false;

// final String banner_ad_unit_id =
//     Platform.isAndroid ? "3a7462a5966b5519" : "IOS_BANNER_AD_UNIT_ID";

// void initializeBannerAds() {
//   // Banners are automatically sized to 320x50 on phones and 728x90 on tablets
//   AppLovinMAX.createBanner(banner_ad_unit_id, AdViewPosition.bottomCenter);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await MobileAds.instance.initialize();

  // Map? sdkConfiguration = await AppLovinMAX.initialize(
  //     "T3OSk_NeoPgCDGWZ4vqJSXw-2onUWnenzLBwUQJh1f_uGVM_ITzGBpKVEKsTncE-tyfrnesaXAZJW4_bCN8RVB");

  // initializeInterstitialAds();

// SDK is initialized, start loading ads
  // loadAdmobIntAd();

  // await Firebase.initializeApp(options: FirebaseOptions(apiKey: apiKey, appId: "1:998124920786:android:b4ec5b469c4d2392a9320b", messagingSenderId: messagingSenderId, projectId: "tor-movie-d52b6"));
  await FacebookAudienceNetwork.init(
      testingId:"fed9b40c-ef5c-4d27-80b4-10ca1ad1abe1" /*"25d8e60f-49b5-4ed6-9e7f-82833a5b1f65"*/);
await  UnityAds.initialize();

//  FacebookAd.loadInterstitialAd();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGo Anime',
      // debugShowCheckedModeBanner: false,

      theme: ThemeData(
        backgroundColor: const Color(0xff95C8D8),
        primaryColor: const Color(
          0xff003366,
        ),
      ),
      home: Categories(),
    );
  }
}
