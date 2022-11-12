import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FaceBookNativeAd extends StatelessWidget {
  const FaceBookNativeAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FacebookNativeAd(
      // isMediaCover: ,
      // this is where i get no fill error
      placementId:
          "1490795468052198_1490795571385521" /*"1219580092285497_1219581955618644"*/,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 350,
      backgroundColor:const  Color.fromARGB(255, 241, 241, 241),
      // backgroundColor: primaryColor.,
      titleColor: Colors.black,
      descriptionColor: Colors.black,
      // isMediaCover: true,
      buttonColor: Colors.white,
      buttonTitleColor: Colors.black,
      buttonBorderColor: Colors.grey,
      // bannerAdSize: NativeBannerAdSize.HEIGHT_120,
      labelColor: Colors.white,
      keepAlive:
          true, //set true if you do not want adview to refresh on widget rebuild
      keepExpandedWhileLoading:
          true, // set false if you want to collapse the native ad view when the ad is loading
      expandAnimationDuraion:
          300, //in milliseconds. Expands the adview with animation when ad is loaded
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
    );
  }
}
