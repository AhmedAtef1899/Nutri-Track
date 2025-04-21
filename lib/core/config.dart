
import 'dart:convert';

import 'package:flutter/services.dart';

abstract class Config {
  static Map localization = {};
  static loadLanguage(String lang) async{
    String translation;
    if (lang == 'Arabic') {
      translation = await rootBundle.loadString("asset/localization/ar.json");
    }
    else {
      translation = await rootBundle.loadString("asset/localization/en.json");
    }
    localization = jsonDecode(translation);
  }
}