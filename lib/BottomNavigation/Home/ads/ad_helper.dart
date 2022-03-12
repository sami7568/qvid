

import 'dart:io';

class AdHelper{
//banner
  static String get bannerAdUnitId{
    if (Platform.isAndroid) {
      //test unit ids
      //return "ca-app-pub-3940256099942544/6300978111";
      return "ca-app-pub-6000720254274281/4898622826";
    }
    else if (Platform.isIOS) {
      //test unit ids
     // return "ca-app-pub-3940256099942544/2934735716";
      return "ca-app-pub-6000720254274281/6185136371";
    }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

  //interstital
  static String get InterstitialAdUnitId{
    if (Platform.isAndroid) {
      //test unit ids
      //return "ca-app-pub-3940256099942544/1033173712";
      return "ca-app-pub-6000720254274281/4323907755";

    }
    else if (Platform.isIOS) {
      //test unit ids
      return "ca-app-pub-6000720254274281/1039307820";
      //return "ca-app-pub-3940256099942544/4411468910";
    }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

  //reward
  static String get rewardUnitId{
    if (Platform.isAndroid) {
      //test unit ids
      //return "ca-app-pub-3940256099942544/5224354917";
      return "ca-app-pub-6000720254274281/9384662740";
    }
    else if (Platform.isIOS) {
      //test unit idss
       return "ca-app-pub-6000720254274281/9478402173";
      //return "ca-app-pub-3940256099942544/5135589807";
     }
    else{
      throw UnsupportedError("Unsupported platform");
    }
  }

}