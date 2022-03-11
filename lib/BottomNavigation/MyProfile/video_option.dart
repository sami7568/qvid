import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/BottomNavigation/Home/comment_sheet.dart';
import 'package:qvid/Components/custom_button.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Theme/colors.dart';

import '../Home/ads/ad_helper.dart';

class VideoOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoOption();
  }
}

class VideoOption extends StatefulWidget {
  @override
  _VideoOptionState createState() => _VideoOptionState();
}

class _VideoOptionState extends State<VideoOption> {
  bool isLiked = false;
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
    _isInterstitialAdLoaded?_interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
    _isInterstitialAdLoaded?_interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
    var locale = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: ()=>backpress(),
      child: FadedSlideAnimation(
        Stack(
          children: <Widget>[
            _isBottomBannesAdLoaded ?Container(height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd,),):Container(),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/thumbnails/food/Layer 783.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            AppBar(
              actions: <Widget>[
                PopupMenuButton(
                  color: backgroundColor,
                  icon: Icon(Icons.more_vert, color: secondaryColor),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  onSelected: (dynamic value) => Navigator.pop(context),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text(locale.delete!),
                        value: locale.delete,
                        textStyle: TextStyle(color: secondaryColor),
                      ),
                    ];
                  },
                ),
              ],
            ),

            Positioned.directional(
              textDirection: Directionality.of(context),
              end: -10.0,
              bottom: 80.0,
              child: Column(
                children: <Widget>[
                  CustomButton(
                    ImageIcon(
                      AssetImage('assets/icons/ic_views.png'),
                      color: secondaryColor,
                    ),
                    '1.2k',
                  ),
                  CustomButton(
                      ImageIcon(
                        AssetImage('assets/icons/ic_comment.png'),
                        color: secondaryColor,
                      ),
                      '287', onPressed: () {
                    commentSheet(context);
                  }),
                  CustomButton(
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: secondaryColor,
                    ),
                    '8.2k',
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                  SizedBox(height: 12.0),
                  CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.webp'))
                ],
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 12.0,
              bottom: 72.0,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '@emiliwilliamson\n',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                  TextSpan(text: locale.comment8),
                  TextSpan(
                      text: '  ${locale.seeMore}',
                      style: TextStyle(
                          color: secondaryColor.withOpacity(0.5),
                          fontStyle: FontStyle.italic))
                ]),
              ),
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
