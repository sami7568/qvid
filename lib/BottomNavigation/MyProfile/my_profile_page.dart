import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/Components/profile_page_button.dart';
import 'package:qvid/Components/row_item.dart';
import 'package:qvid/Components/sliver_app_delegate.dart';
import 'package:qvid/Components/tab_grid.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/BottomNavigation/MyProfile/edit_profile.dart';
import 'package:qvid/BottomNavigation/MyProfile/followers.dart';
import 'package:qvid/Theme/colors.dart';
import 'package:qvid/BottomNavigation/Explore/explore_page.dart';
import 'package:qvid/BottomNavigation/MyProfile/following.dart';

import '../Home/ads/ad_helper.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyProfileBody();
  }
}

class MyProfileBody extends StatefulWidget {
  @override
  _MyProfileBodyState createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  final key = UniqueKey();
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
    var locale = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: ()=>backpress(),
      child: Padding(
        padding: EdgeInsets.only(bottom: 64.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
           bottomNavigationBar: _isBottomBannesAdLoaded ?Container(height: _bannerAd.size.height.toDouble(),
           child: AdWidget(ad: _bannerAd,),):null,

        backgroundColor: darkColor,
          body: Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: SafeArea(
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 404.0,
                          floating: false,
                          actions: <Widget>[
                            Theme(
                              data: Theme.of(context).copyWith(
                                cardColor: backgroundColor,
                              ),
                              child: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: secondaryColor,
                                ),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none),
                                onSelected: (dynamic value) {
                                  if (value == locale!.changeLanguage) {
                                    Navigator.pushNamed(
                                        context, PageRoutes.languagePage);
                                  } else if (value == locale.help) {
                                    Navigator.pushNamed(
                                        context, PageRoutes.helpPage);
                                  } else if (value == locale.termsOfUse) {
                                    Navigator.pushNamed(
                                        context, PageRoutes.tncPage);
                                  } else if (value == locale.logout) {
                                    Phoenix.rebirth(context);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text(locale!.changeLanguage!),
                                      value: locale.changeLanguage,
                                      textStyle: TextStyle(color: secondaryColor),
                                    ),
                                    PopupMenuItem(
                                      child: Text(locale.help!),
                                      value: locale.help,
                                      textStyle: TextStyle(color: secondaryColor),
                                    ),
                                    PopupMenuItem(
                                      child: Text(locale.termsOfUse!),
                                      value: locale.termsOfUse,
                                      textStyle: TextStyle(color: secondaryColor),
                                    ),
                                    PopupMenuItem(
                                      child: Text(locale.logout!),
                                      value: locale.logout,
                                      textStyle: TextStyle(color: secondaryColor),
                                    )
                                  ];
                                },
                              ),
                            )
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Column(
                              children: <Widget>[
                                Spacer(flex: 10),
                                CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage:
                                      AssetImage('assets/images/user.webp'),
                                ),
                                Spacer(),
                                Text(
                                  'Samantha Smith',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '@imsamanthasmith',
                                  style: TextStyle(
                                      fontSize: 10, color: disabledTextColor),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ImageIcon(
                                      AssetImage("assets/icons/ic_fb.png"),
                                      color: secondaryColor,
                                      size: 10,
                                    ),
                                    SizedBox(width: 16),
                                    ImageIcon(
                                      AssetImage("assets/icons/ic_twt.png"),
                                      color: secondaryColor,
                                      size: 10,
                                    ),
                                    SizedBox(width: 16),
                                    ImageIcon(
                                      AssetImage("assets/icons/ic_insta.png"),
                                      color: secondaryColor,
                                      size: 10,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  locale!.comment5!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 8),
                                ),
                                Spacer(),
                                ProfilePageButton(
                                  locale.editProfile,
                                  () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile()));
                                  },
                                  width: 120,
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RowItem(
                                        '1.2m',
                                        locale.liked,
                                        Scaffold(
                                          appBar: AppBar(
                                            title: Text('Liked'),
                                          ),
                                          body: TabGrid(
                                            food,
                                          ),
                                        )),
                                    RowItem('12.8k', locale.followers,
                                        FollowersPage()),
                                    RowItem('1.9k', locale.following,
                                        FollowingPage()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: SliverAppBarDelegate(
                            TabBar(
                              labelColor: mainColor,
                              unselectedLabelColor: lightTextColor,
                              indicatorColor: transparentColor,
                              tabs: [
                                Tab(icon: Icon(Icons.dashboard)),
                                Tab(icon: Icon(Icons.favorite_border)),
                                Tab(icon: Icon(Icons.bookmark_border)),
                              ],
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: <Widget>[
                        FadedSlideAnimation(
                          TabGrid(
                            food + food,
                            viewIcon: Icons.remove_red_eye,
                            views: '2.2k',
                            onTap: () => Navigator.pushNamed(
                                context, PageRoutes.videoOptionPage),
                          ),
                          beginOffset: Offset(0, 0.3),
                          endOffset: Offset(0, 0),
                          slideCurve: Curves.linearToEaseOut,
                        ),
                        FadedSlideAnimation(
                          TabGrid(
                            dance,
                            icon: Icons.favorite,
                          ),
                          beginOffset: Offset(0, 0.3),
                          endOffset: Offset(0, 0),
                          slideCurve: Curves.linearToEaseOut,
                        ),
                        FadedSlideAnimation(
                          TabGrid(
                            lol,
                            icon: Icons.bookmark,
                          ),
                          beginOffset: Offset(0, 0.3),
                          endOffset: Offset(0, 0),
                          slideCurve: Curves.linearToEaseOut,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
