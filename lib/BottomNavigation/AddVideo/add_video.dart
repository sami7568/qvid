import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';

import '../Home/ads/ad_helper.dart';

class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {

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
  void _createInterstitionalAd()async{
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

   _isInterstitialAdLoaded? _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
    //  _isInterstitialAdLoaded?_interstitialAd.show():null;
  }
  void _createrewardedAd()async{
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
   _isrewardedAdLoaded? _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
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
    return  _isInterstitialAdLoaded?_interstitialAd.show():false;
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
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: _isBottomBannesAdLoaded ?Container(height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd,),):null,

    body: FadedSlideAnimation(
        Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/video 2.png',
              fit: BoxFit.fill,
              height: ht,
              width: wt,
            ),
            Positioned(
              top: 28,
              left: 4,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: secondaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              width: wt,
              bottom: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.camera_front,
                    color: secondaryColor,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: videoCall,
                      child: Icon(
                        Icons.videocam,
                        color: secondaryColor,
                        size: 30,
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(
                        context, PageRoutes.addVideoFilterPage),
                  ),
                  Icon(
                    Icons.flash_off,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
            Positioned(
              width: wt,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.swipeUpForGallery!,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
