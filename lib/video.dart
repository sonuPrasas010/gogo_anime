import 'dart:developer';
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'faceboook_native_ad.dart';
import 'functionality.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inAppWeb;

class VideoPlayer extends StatefulWidget {
  final String url;
  VideoPlayer(this.url);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  int? _progress = 0;
  // static const _insets = 16.0;
  // BannerAd? _inlineAdaptiveAd;
  // bool _isLoaded = false;
  // AdSize? _adSize;
  // late Orientation _currentOrientation;
  // double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _currentOrientation = MediaQuery.of(context).orientation;
  //   _loadAd();
  // }

  // void _loadAd() async {
  //   if (_isLoaded) return;
  //   await _inlineAdaptiveAd?.dispose();
  //   setState(() {
  //     _inlineAdaptiveAd = null;
  //     _isLoaded = false;
  //   });

  //   // Get an inline adaptive size for the current orientation.
  //   AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
  //       _adWidth.truncate());

  //   _inlineAdaptiveAd = BannerAd(
  //     // TODO: replace this test ad unit with your own ad unit.
  //     adUnitId: /* "ca-app-pub-7282495026623737/5203853191"*/
  //         'ca-app-pub-3940256099942544/9214589741',
  //     size: size,
  //     request: AdRequest(),

  //     listener: BannerAdListener(
  //       onAdLoaded: (Ad ad) async {
  //         print('Inline adaptive banner loaded: ${ad.responseInfo}');

  //         // After the ad is loaded, get the platform ad size and use it to
  //         // update the height of the container. This is necessary because the
  //         // height can change after the ad is loaded.
  //         BannerAd bannerAd = (ad as BannerAd);
  //         final AdSize? size = await bannerAd.getPlatformAdSize();
  //         if (size == null) {
  //           print('Error: getPlatformAdSize() returned null for $bannerAd');
  //           return;
  //         }

  //         setState(() {
  //           _inlineAdaptiveAd = bannerAd;
  //           _isLoaded = true;
  //           _adSize = size;
  //         });
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('Inline adaptive banner failedToLoad: $error');
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   await _inlineAdaptiveAd!.load();
  // }

  // Widget _getAdWidget() {
  //   return OrientationBuilder(
  //     builder: (context, orientation) {
  //       if (_currentOrientation == orientation &&
  //           _inlineAdaptiveAd != null &&
  //           _isLoaded &&
  //           _adSize != null) {
  //         return Align(
  //             child: Container(
  //           width: _adWidth,
  //           height: _adSize!.height.toDouble(),
  //           child: AdWidget(
  //             ad: _inlineAdaptiveAd!,
  //           ),
  //         ));
  //       }
  //       // Reload the ad if the orientation changes.
  //       if (_currentOrientation != orientation) {
  //         _currentOrientation = orientation;
  //         _loadAd();
  //       }
  //       return Container();
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _inlineAdaptiveAd?.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    // initializeMRecAds();
    super.initState();
  }

  // final String _mrec_ad_unit_id =
  //     Platform.isAndroid ? "db56c82870d6daae" : "IOS_MREC_AD_UNIT_ID";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: inAppWeb.InAppWebView(
                initialUrlRequest: inAppWeb.URLRequest(
                    url: Uri.parse(
                  widget.url,
                )),
                initialOptions: inAppWeb.InAppWebViewGroupOptions(
                  crossPlatform: inAppWeb.InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    transparentBackground: true,
                    // useShouldInterceptAjaxRequest: true,
                  ),
                ),
                onProgressChanged: (_, progress) {
                  if (_progress != null) {
                    setState(() {
                      _progress = progress;
                    });
                  }
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  if (navigationAction.request.url
                      .toString()
                      .startsWith("https://play.google.com")) {
                    Functionality.launchUniversalLinkIos(
                        defaultUrl: "${navigationAction.request.url}");
                  }

                  return inAppWeb.NavigationActionPolicy.CANCEL;
                },
                onExitFullscreen: (controller) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                },
                onEnterFullscreen: (controller) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeLeft]);
                  // Future.delayed(Duration(seconds: 2), () async {
                  //   debugPrint(await controller.evaluateJavascript(
                  //       source:
                  //           """window.onload= function(){ var far= document.getElementsByTagName('iframe');
                  //               for (var i = 0; i < far.length; ++i) {

                  //                  if(far[i].getAttribute('style').startsWith('width: 100% !important')
                  //                 {
                  //                    far[i].style.display = 'none';
                  //                alert( far[i].getAttribute('style'));
                  //                far[i].remove();
                  //                }

                  //                }
                  //                }     """));
                  // });
                },
                onLoadStop: (controller, url) async {
                  _progress = null;
                },
              ),
            ),
            if (_progress != null) Text("Video is Loading $_progress%"),
            // _getAdWidget(),
            //    const Spacer(),
            // _adWidget,
            // this is supposed to load below here
            //  as you can see test ad works fineG
            // but in other device it doesn't work
            // thank you
            // const FaceBookNativeAd(),
          ],
        ),
      ),
    );
  }
}
