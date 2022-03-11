import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/BottomNavigation/Home/ads/ad_helper.dart';
import 'package:qvid/BottomNavigation/Home/following_tab.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Theme/colors.dart';

List<String> videos1 = [
  'assets/videos/3.mp4',
  'assets/videos/1.mp4',
  'assets/videos/2.mp4',
];

List<String> videos2 = [
  'assets/videos/4.mp4',
  'assets/videos/5.mp4',
  'assets/videos/6.mp4',
];

List<String> imagesInDisc1 = [
  'assets/user/user1.png',
  'assets/user/user2.png',
  'assets/user/user3.png',
];

List<String> imagesInDisc2 = [
  'assets/user/user4.png',
  'assets/user/user3.png',
  'assets/user/user1.png',
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
   late InterstitialAd _interstitialAd;
   late BannerAd _bannerAd;
   late RewardedAd _rewardedAd;
   bool _isBottomBannesAdLoaded = false;
   bool _isrewardedAdLoaded = false;
   bool _isInterstitialAdLoaded = false;
   void _createBottomBannerAd(){

     _bannerAd = BannerAd(
       adUnitId: AdHelper.bannerAdUnitId,
       size: AdSize.banner,
       request: AdRequest(),
       listener: BannerAdListener(
         onAdLoaded: (_){
           print("loaded successfully ads");
           setState(() {
             _isBottomBannesAdLoaded = true;
           });
         },
           onAdFailedToLoad: (ad,error){
           print(error);
           ad.dispose();
       }
       ),
     );
     _bannerAd.load();
   }
   void _createInterstitionalAd(){
     InterstitialAd.load(
         adUnitId: AdHelper.InterstitialAdUnitId,
         request: AdRequest(),
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print("interstitial ad loaded");
             // Keep a reference to the ad so you can show it later.

             setState(() {
               this._interstitialAd = ad;
               _isInterstitialAdLoaded = true;
             });
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('InterstitialAd failed to load: $error');
           },
         ));
     _isInterstitialAdLoaded?
     _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('%ad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
       },
       onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
     ):null;
     _isInterstitialAdLoaded?_interstitialAd.show():null;
   }
   void _createrewardedAd(){
     RewardedAd.load(
         request: AdRequest(),
         adUnitId: AdHelper.rewardUnitId,
         rewardedAdLoadCallback: RewardedAdLoadCallback(
             onAdLoaded: (RewardedAd ad) {
             print('$ad loaded.');
                // Keep a reference to the ad so you can show it later.
                 this._rewardedAd = ad;
                 setState(() {
                   _isrewardedAdLoaded = true;
                 });
             },
             onAdFailedToLoad: (LoadAdError error) {
                 print('RewardedAd failed to load: $error');
             },
     ));
     _isrewardedAdLoaded?_rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (RewardedAd ad) =>
           print('$ad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (RewardedAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
       },
       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
       },
       onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
     ):null;

     _isrewardedAdLoaded?
     _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
       // Reward the user for watching an ad.
     }):null;
   }
   backpress(){
     print("back press");
   // return  _isInterstitialAdLoaded?_interstitialAd.show():false;
    return  _isrewardedAdLoaded? _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
    }):false;
  }
   @override
   void initState() {
     super.initState();
     _createInterstitionalAd();
     _createBottomBannerAd();
     _createrewardedAd();
   }
   @override
   void dispose() {
     super.dispose();
     _bannerAd.dispose();
     _rewardedAd.dispose();
     _interstitialAd.dispose();
   }


  @override
  Widget build(BuildContext context) {
   /* _createInterstitionalAd();
    _createBottomBannerAd();
    _createrewardedAd();
   */
    _isInterstitialAdLoaded?_interstitialAd.show():null;
    _isrewardedAdLoaded?
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
    }):null;
    List<Tab> tabs = [
      Tab(text: AppLocalizations.of(context)!.following),
      Tab(text: AppLocalizations.of(context)!.related),
    ];
    return WillPopScope(
      onWillPop :()=>backpress(),
      child: DefaultTabController(
        length: tabs.length,
        child: Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                FollowingTabPage(videos1, imagesInDisc1, false),
                FollowingTabPage(videos2, imagesInDisc2, true),
              ],
            ),
             SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            indicator: BoxDecoration(color: transparentColor),
                            tabs: tabs,
                          ),
                          _isBottomBannesAdLoaded ?
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: _bannerAd.size.width.toDouble(),
                              height: _bannerAd.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd,),),
                          ):Container()
                        ],
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: 14,
                        start: 84,
                        child: CircleAvatar(
                          backgroundColor: mainColor,
                          radius: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  // bottomNavigationBar: _isBottomBannesAdLoaded ?Container(height: _bannerAd.size.width.toDouble(),
   //child: AdWidget(ad: _bannerAd,),):null,


}
