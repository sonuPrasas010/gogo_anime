import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'book_mark_page.dart';
import 'functionality.dart';
import 'list_page.dart';
import 'search.dart';
import 'services/DataFetcher.dart';

String? buildNumber;
String? packageName;

void loadAppInfo() async {
  var packageInfo = await PackageInfo.fromPlatform();
  packageName = packageInfo.packageName;
  buildNumber = packageInfo.buildNumber;
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with TickerProviderStateMixin {
  late TabController _tabController;
  // BannerAd? _bannerAd;
  // AdManagerBannerAd? _adManagerBannerAd;
  // var _bannerAdIsLoaded = false;

  // BannerAd? _anchoredAdaptiveAd;
  // bool _isLoaded = false;

  late SharedPreferences _prefs;

  void checkIfIsFirstTime(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    var firstOpenedDate = _prefs.getString("first_opened_date");
    var hasAlreadyRated = _prefs.getBool("has_already_rated") ?? false;
    log(firstOpenedDate.toString());
    if (firstOpenedDate == null) {
      await _prefs.setString("first_opened_date", DateTime.now().toString());
      return;
    }
    log("this is not the first time opened");
    if (DateTime.now().difference(DateTime.parse(firstOpenedDate)).inDays < 3 ||
        hasAlreadyRated) {
      log("difference is 3 days $hasAlreadyRated on $firstOpenedDate");
      return;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(
                  "Are you enjoying our app? Would you like to rate us on playstore?"),
              actions: [
                TextButton(
                  child: const Text("not now"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("never"),
                  onPressed: () {
                    _prefs.setBool("has_already_rated", true);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("rate now"),
                  onPressed: () async {
                    if (await launchUrl(
                      Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.godevs.yts_movie_downloader",
                      ),
                      mode: LaunchMode.externalApplication,
                    )) {
                      await _prefs.setBool("has_already_rated", true);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ));
  }

  @override
  void initState() {
    loadAppInfo();
    checkAppVersion();
    _tabController = TabController(length: 5, vsync: this);
    // loadBannerAd();

    super.initState();
    _tabController.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    log("did change dependencies called again");
    checkIfIsFirstTime(context);
    // initializeBannerAds();
    // AppLovinMAX.showBanner(banner_ad_unit_id);
    super.didChangeDependencies();
    // _loadAd();
  }

  // Future<void> _loadAd() async {
  //   // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
  //   final AnchoredAdaptiveBannerAdSize? size =
  //       await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
  //           MediaQuery.of(context).size.width.truncate());

  //   if (size == null) {
  //     print('Unable to get height of anchored banner.');
  //     return;
  //   }

  //   _anchoredAdaptiveAd = BannerAd(
  //     // TODO: replace these test ad units with your own ad unit.
  //     adUnitId: /*'ca-app-pub-7282495026623737/5203853191'*/ Platform.isAndroid
  //         ? 'ca-app-pub-3940256099942544/6300978111'
  //         : 'ca-app-pub-3940256099942544/2934735716',
  //     size: size,
  //     request: AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('$ad loaded: ${ad.responseInfo}');
  //         setState(() {
  //           // When the ad is loaded, get the ad size and use it to set
  //           // the height of the ad container.
  //           _anchoredAdaptiveAd = ad as BannerAd;
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('Anchored adaptive banner failedToLoad: $error');
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   return _anchoredAdaptiveAd!.load();
  // }

  // void loadBannerAd() {
  //   if (_anchoredAdaptiveAd != null && _isLoaded) return;
  //   _bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: /*'ca-app-pub-7282495026623737/5203853191'*/
  //           Platform.isAndroid
  //               ? 'ca-app-pub-3940256099942544/6300978111'
  //               : 'ca-app-pub-3940256099942544/2934735716',
  //       listener: BannerAdListener(
  //         onAdLoaded: (Ad ad) {
  //           print('$BannerAd loaded.');
  //           setState(() {
  //             _bannerAdIsLoaded = true;
  //           });
  //           // Future.delayed(const Duration(minutes: 1), () {
  //           //   _bannerAd!.dispose();
  //           //   _bannerAd = null;
  //           //   loadBannerAd();
  //           // });
  //         },
  //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //           print('$ad failedToLoad: $error');
  //           ad.dispose();
  //           _bannerAd = null;
  //           loadBannerAd();
  //         },
  //         onAdOpened: (Ad ad) => print('$ad onAdOpened.'),
  //         onAdClosed: (Ad ad) => print('$ad onAdClosed.'),
  //       ),
  //       request: AdRequest())
  //     ..load();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // backgroundColor: const Color(0xff4C516D),
        persistentFooterButtons: null,
        //  [
        // _bannerAd != null && _bannerAdIsLoaded
        //     ? SizedBox(
        //         height: _bannerAd?.size.height.toDouble(),
        //         width: _bannerAd?.size.width.toDouble(),
        //         child: AdWidget(ad: _bannerAd!))
        //     : Container(),
        // if (_anchoredAdaptiveAd != null && _isLoaded)
        //   Container(
        //     color: Colors.green,
        //     width: _anchoredAdaptiveAd!.size.width.toDouble(),
        //     height: _anchoredAdaptiveAd!.size.height.toDouble(),
        //     child: AdWidget(ad: _anchoredAdaptiveAd!),
        //   )

        // sonu

        // MaxAdView(
        //     adUnitId: banner_ad_unit_id,

        //     adFormat: AdFormat.banner,
        //     listener: AdViewAdListener(onAdLoadedCallback: (ad) {
        //       print("ad loaded $ad");
        //     }, onAdLoadFailedCallback: (adUnitId, error) {
        //       print("error to load ad $error");
        //     }, onAdClickedCallback: (ad) {
        //       print("ad clicked $ad");
        //     }, onAdExpandedCallback: (ad) {
        //       print("ad expanded $ad");
        //     }, onAdCollapsedCallback: (ad) {
        //       print("ad collapsed $ad");
        //     },)),
        // ],
        /*FacebookBannerAd(
          // placementId: "YOUR_PLACEMENT_ID",
          placementId: "1490795468052198_1490795574718854", //testid
          bannerSize: BannerSize.STANDARD,
          keepAlive: true,

          listener: (result, value) {},
        ),
        */
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text("GoGo Anime"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Search(),
                  ),
                );
              },
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            // unselectedLabelStyle: TextStyle(color: Colors.red),
            tabs: const [
              FittedBox(
                child: Tab(
                  iconMargin: EdgeInsets.all(0),
                  text: "Bookmarks",
                ),
              ),
              FittedBox(
                child: Tab(
                  iconMargin: EdgeInsets.all(0),
                  text: "Recent Release",
                ),
              ),
              FittedBox(
                child: Tab(
                  text: "New Season",
                ),
              ),
              FittedBox(
                child: Tab(
                  text: "Popular",
                ),
              ),
              FittedBox(
                child: Tab(
                  text: "Movies",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BookMarkPage(),
            ListPage(
              url: "http://toranime.online/apis/anime_home.php?c=p",
              title: "",
            ),
            ListPage(
              url: "http://toranime.online/apis/anime.php?c=new-season",
              title: "",
            ),
            ListPage(
              url: "http://toranime.online/apis/anime.php?c=popular",
              title: "",
            ),
            ListPage(
              url: "http://toranime.online/apis/anime.php?c=anime-movies",
              title: "",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkAppVersion() async {
    // showLicensePage(context: context)
    DataFetcher dataFetcher = DataFetcher();
    // previously http://toranime.online/apis/check-kiss-version.php & http://toranime.online/apis/check-gogo-version1.php
    var data = await dataFetcher
        .fetchVideo("http://toranime.online/apis/check-gogo-version2.php");
    var appVersion = await PackageInfo.fromPlatform();
    int version = int.parse(appVersion.buildNumber);

    if (data['version'] > version) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: const Text("Update"),
              content: data['msg'] ?? const Text("New update available"),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    Functionality.launchUniversalLinkIos(
                        defaultUrl: data['url']);
                  },
                  icon: const Icon(Icons.upgrade),
                  label: const Text("Update"),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
