import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qvid/Locale/locale.dart';
import 'package:qvid/Routes/routes.dart';
import 'package:qvid/Theme/colors.dart';

import '../Home/ads/ad_helper.dart';

class NotificationMessages extends StatefulWidget {
  @override
  _NotificationMessagesState createState() => _NotificationMessagesState();
}

class Notif {
  final String name;
  final String? desc;
  final String time;
  final String image;
  final String notifImage;
  final IconData icon;

  Notif(
      this.name, this.desc, this.time, this.image, this.notifImage, this.icon);
}

class _NotificationMessagesState extends State<NotificationMessages> {
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
    List<Notif> notification = [
      Notif(
          "Emili Williamson",
          locale.likedYourVideo,
          "5 " + locale.minAgo!,
          "assets/user/user1.png",
          "assets/thumbnails/dance/Layer 951.png",
          Icons.favorite),
      Notif(
          "Kesha Taylor",
          locale.commentedOnYour,
          "5 " + locale.minAgo!,
          "assets/user/user2.png",
          "assets/thumbnails/dance/Layer 952.png",
          Icons.message),
      Notif(
          "Ling Tong",
          locale.commentedOnYour,
          "5 " + locale.minAgo!,
          "assets/user/user3.png",
          "assets/thumbnails/food/Layer 783.png",
          Icons.message),
      Notif(
          "Linda Johnson",
          locale.likedYourVideo,
          "5 " + locale.minAgo!,
          "assets/user/user4.png",
          "assets/thumbnails/food/Layer 786.png",
          Icons.favorite),
      Notif("George Smith", locale.startedFollowing, "5 " + locale.minAgo!,
          "assets/user/user1.png", "assets/images/user.webp", Icons.add),
    ];

    List<String?> messages = [
      locale.heyILikeYourVideos,
      locale.yesIUse,
      locale.noWorries,
      locale.ohThank,
      locale.alreadyLikedIt,
    ];
    return WillPopScope(
      onWillPop: ()=>backpress(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(

        appBar: AppBar(
            titleSpacing: 0.0,
            title: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicator: BoxDecoration(color: transparentColor),
                isScrollable: true,
                labelColor: mainColor,
                labelStyle: Theme.of(context).textTheme.headline6,
                unselectedLabelColor: disabledTextColor,
                tabs: <Widget>[
                  Tab(text: locale.notifications),
                  Tab(text: locale.messages),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              FadedSlideAnimation(
                NotificationPage(notification: notification),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
              FadedSlideAnimation(
                MessagesPage(notification: notification, messages: messages),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final List<Notif> notification;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
    return  _isrewardedAdLoaded?
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
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
    return Stack(
      children: [
        ListView.builder(
            itemCount: widget.notification.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Stack(children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage(widget.notification[index].image)),
                  title: Text(
                    widget.notification[index].name,
                    style: TextStyle(color: secondaryColor),
                  ),
                  subtitle: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: widget.notification[index].desc! + ' ',
                      style: TextStyle(color: lightTextColor),
                    ),
                    TextSpan(
                        text: widget.notification[index].time,
                        style: TextStyle(color: lightTextColor.withOpacity(0.15)))
                  ])),
                  trailing: Container(
                    width: 50,
                    //height: 45,
                    child: widget.notification[index].icon == Icons.add
                        ? CircleAvatar(
                            radius: 25.0,
                            backgroundImage: AssetImage('assets/images/user.webp'),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image:
                                        AssetImage(widget.notification[index].notifImage),
                                    fit: BoxFit.fill))),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, PageRoutes.userProfilePage),
                ),
                Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: 55,
                    bottom: 10,
                    child: CircleAvatar(
                      backgroundColor: mainColor,
                      child: Icon(
                        widget.notification[index].icon,
                        color: Colors.white,
                        size: 10,
                      ),
                      radius: 10,
                    )),
              ]);
            }),
        _isBottomBannesAdLoaded ?
        Positioned(
          bottom: 90,
//          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd,),),
        ):Container()
      ],
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({
    Key? key,
    required this.notification,
    required this.messages,
  }) : super(key: key);

  final List<Notif> notification;
  final List<String?> messages;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
    return  _isrewardedAdLoaded?
    _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
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
    return Stack(
      children: [
        ListView.builder(
            itemCount: widget.notification.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage(widget.notification[index].image)),
                title: Text(
                  widget.notification[index].name,
                  style: TextStyle(color: secondaryColor),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      widget.messages[index]!,
                      style: TextStyle(color: lightTextColor),
                    ),
                  ],
                ),
                trailing: Text(
                  widget.notification[index].time,
                  style: TextStyle(color: lightTextColor.withOpacity(0.15)),
                ),
                onTap: () => Navigator.pushNamed(context, PageRoutes.chatPage),
              );
            }),
        _isBottomBannesAdLoaded ?
        Positioned(
          bottom: 90,
//          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd,),),
        ):Container()
      ],
    );
  }
}
