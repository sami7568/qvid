import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/Components/continue_button.dart';
import 'package:qvid/Components/entry_field.dart';
import 'package:qvid/Components/post_thumb_list.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Theme/colors.dart';

import '../Home/ads/ad_helper.dart';

class PostInfo extends StatefulWidget {
  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  var icon = Icons.check_box_outline_blank;
  bool isSwitched1 = false;
  bool isSwitched2 = false;

  final List<PostThumbList> thumbLists = [
    PostThumbList(dance),
  ];
  static List<String> dance = [
    'assets/thumbnails/dance/Layer 951.png',
    'assets/thumbnails/dance/Layer 952.png',
    'assets/thumbnails/dance/Layer 953.png',
    'assets/thumbnails/dance/Layer 954.png',
    'assets/thumbnails/dance/Layer 951.png',
    'assets/thumbnails/dance/Layer 952.png',
    'assets/thumbnails/dance/Layer 953.png',
    'assets/thumbnails/dance/Layer 954.png',
  ];
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
    return WillPopScope(
      onWillPop: ()=>backpress(),
      child: Scaffold(
        bottomNavigationBar: _isBottomBannesAdLoaded ?
        Container(height: _bannerAd.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd,),):null,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.post!),
          centerTitle: true,
        ),
        body: FadedSlideAnimation(
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                EntryField(
                  prefix: FadedScaleAnimation(
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.webp'),
                    ),
                  ),
                  label: '    ' + AppLocalizations.of(context)!.describeVideo!,
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.selectCover! + '\n',
                  style: TextStyle(color: secondaryColor, fontSize: 18),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: thumbLists.length,
                    itemBuilder: (context, index) {
                      return thumbLists[index];
                    }),
                SizedBox(height: 12.0),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.commentOff!,
                    style: TextStyle(color: secondaryColor),
                  ),
                  trailing: Switch(
                    value: isSwitched1,
                    onChanged: (value) {
                      setState(() {
                        isSwitched1 = value;
                        //print(isSwitched1);
                      });
                    },
                    inactiveThumbColor: disabledTextColor,
                    inactiveTrackColor: darkColor,
                    activeTrackColor: darkColor,
                    activeColor: mainColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.saveToGallery!,
                    style: TextStyle(color: secondaryColor),
                  ),
                  trailing: Switch(
                    value: isSwitched2,
                    onChanged: (value) {
                      setState(() {
                        isSwitched2 = value;
                        //print(isSwitched2);
                      });
                    },
                    inactiveThumbColor: disabledTextColor,
                    inactiveTrackColor: darkColor,
                    activeTrackColor: darkColor,
                    activeColor: mainColor,
                  ),
                ),
                Spacer(),
                CustomButton(
                  text: AppLocalizations.of(context)!.postVideo,
                  onPressed: () {
                    Phoenix.rebirth(context);
                  },
                )
              ],
            ),
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}
