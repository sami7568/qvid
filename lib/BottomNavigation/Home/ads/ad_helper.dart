

import 'dart:io';

class AdHelper{
//banner
  static String get bannerAdUnitId{
    if (Platform.isAndroid) {
      return "ca-app-pub-6000720254274281/4898622826";
      //return "ca-app-pub-3940256099942544/6300978111";
    }
    else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
     // return "ca-app-pub-8926875438170318/3098177725";
    }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

  //interstital
  static String get InterstitialAdUnitId{
    if (Platform.isAndroid) {
      return "ca-app-pub-6000720254274281/4323907755";
      //return "ca-app-pub-3940256099942544/1033173712";
    }
    else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
      //return "ca-app-pub-8926875438170318/2056558794";
    }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

  //reward
  static String get rewardUnitId{
    if (Platform.isAndroid) {
      return "  ca-app-pub-6000720254274281/9384662740";
      //return "  ca-app-pub-3940256099942544/5224354917";
    }
    else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589807";
     // return "ca-app-pub-8926875438170318/8761567947";
    }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

}