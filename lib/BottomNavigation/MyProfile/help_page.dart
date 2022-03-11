import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Theme/colors.dart';

import '../Home/ads/ad_helper.dart';

class Help {
  final String? question;
  final String answer;

  Help(this.question, this.answer);
}

class HelpPage extends StatefulWidget {

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
    var locale = AppLocalizations.of(context)!;
    List<Help> helps = [
      Help(locale.howToCreateAccount,
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin magna velit, posuere eu consequat id, fermentum in ex. Phasellus imperdiet, ante sit amet rhoncus mattis, quam dolor venenatis felis, vitae mollis sapien lorem a justo.\n\nVestibulum ut nunc et tortor porta blandit. Sed tincidunt urna eu urna bibendum iaculis. Duis porttitor ac dui ac mattis. Aenean eu nulla ut dolor accumsan tincidunt. Aliquam viverra mattis arcu.'),
      Help(locale.howToChangePassword,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToPostVideo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToDeleteVideo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToChangeProfileInfo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howCanIShare,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToChangeProfileInfo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToPostVideo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
      Help(locale.howToDeleteVideo,
          'Nulla facilisi. Ut in sapien et risus ullamcorper vestibulum ut eget leo.'),
    ];
    return Scaffold(
      bottomNavigationBar: _isBottomBannesAdLoaded ?
      Container(height: _bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd,),):null,
      appBar: AppBar(
        title: Text(locale.help!),
        centerTitle: true,
      ),
      body: FadedSlideAnimation(
        ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(20.0),
            itemCount: helps.length,
            itemBuilder: (context, index) {
              return RichText(
                text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(height: 1.3),
                    children: [
                      TextSpan(text: helps[index].question),
                      TextSpan(
                        text: '\n' + helps[index].answer + '\n',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: secondaryColor),
                      ),
                    ]),
              );
            }),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
