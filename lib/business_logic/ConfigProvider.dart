import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class ConfigProvider extends ChangeNotifier {
  int measureMode = KG;

  Future<void> changeLanguage(int val) async {
    switch (val) {
      case 1:
        {
          await userPreferences!.setString('language', lList[0].name ?? korean);
          break;
        }
      case 2:
        {
          await userPreferences!.setString('language', lList[1].name ?? korean);
          break;
        }
    }
    notifyListeners();
  }

  void changeMassMeasurement() {
    if (measureMode == KG) {
      measureMode = LBS;
    } else {
      measureMode = KG;
    }
    notifyListeners();
  }

  double getConvertedMass(double mass) {
    if (measureMode == KG) {
      return mass;
    } else {
      return roundDouble((2.2 * mass), 2);
    }
  }

  double getConvertedRM(double rm) {
    if (measureMode == KG) {
      return roundDouble(rm, 2);
    } else
      return roundDouble(2.2 * rm, 2);
  }

  int languageCode() {
    switch (userPreferences!.getString('language')) {
      case english:
        {
          return 1;
        }
      case korean:
        {
          return 2;
        }

      default:
        {
          return 1;
        }
    }
  }

  String? activeLanguage() {
    return userPreferences!.getString('language') ?? korean;
  }

  String trimField(String value) => trimStringField(value);
}
