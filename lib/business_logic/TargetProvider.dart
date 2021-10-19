import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/data/models/TargetModel.dart';
import 'package:workoutnote/data/services/Network.dart';
import 'package:workoutnote/utils/Utils.dart';

class TargetProvider extends ChangeNotifier {
  var targetNameController = TextEditingController();
  List<Target> allTargets = [];
  bool hasRequestDone = false;
  int responseCode = IDLE;

  var sessionKey = userPreferences?.getString('sessionKey');

  Future<int> registerTarget(String targetName, String startDate, String endDate) async {
    var startTimestamp = DateTime.parse(startDate).millisecondsSinceEpoch;
    var endTimestamp = DateTime.parse(endDate).millisecondsSinceEpoch;

    try {
      var response = await WebServices.registerTarget(sessionKey!, targetName, startTimestamp, endTimestamp);
      if (response.statusCode == 200) {
        await fetchAllTargets();
        if (responseCode == SUCCESS) return SUCCESS;
      }
    } on SocketException catch (e) {
      print(e);
      return SOCKET_EXCEPTION;
    } on Error catch (e) {
      print(e);
      return MISC_EXCEPTION;
    }

    return LOADING;
  }

  Future<int> toggleTarget(int targetId) async {
    try {
      var response = await WebServices.toggleTarget(sessionKey!, targetId);
      if (response.statusCode == 200) {
        Target target = allTargets.singleWhere((element) => element.id == targetId);

        if (target.achieved)
          target.achieved = false;
        else
          target.achieved = true;
        notifyListeners();

        return SUCCESS;
      }
    } on SocketException catch (e) {
      print(e);
      return SOCKET_EXCEPTION;
    } on Error catch (e) {
      print(e);
      return MISC_EXCEPTION;
    }

    return LOADING;
  }

  Future<int> deleteTarget(int targetId) async {
    try {
      var response = await WebServices.removeTarget(sessionKey!, targetId);
      if (response.statusCode == 200) {
        allTargets.removeWhere((element) => element.id == targetId);
        notifyListeners();
        return SUCCESS;
      }
    } on SocketException catch (e) {
      print(e);
      return SOCKET_EXCEPTION;
    } on Error catch (e) {
      print(e);
      return MISC_EXCEPTION;
    }

    return LOADING;
  }

  Future<void> fetchAllTargets() async {
    responseCode = LOADING;
    hasRequestDone = true;

    if (allTargets.isNotEmpty) allTargets.clear();
    try {
      var response = await WebServices.fetchTargets(sessionKey!);
      if (response.statusCode == 200) {
        print(response.body);
        var targetResponse = TargetModelResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        allTargets.addAll(targetResponse.targets);
        responseCode = SUCCESS;
        notifyListeners();
      }
    } on SocketException catch (e) {
      print(e);
      responseCode = SOCKET_EXCEPTION;
    } on Error catch (e) {
      print(e);
      responseCode = MISC_EXCEPTION;
    }
  }

  //utils
  int getNthDate(int endTimestamp) {
    var todayTimeStamp = DateTime.now().millisecondsSinceEpoch;
    int numberOfDays = ((endTimestamp - todayTimeStamp) / 86400000).ceil();

    return numberOfDays;
  }

  String getStartDate(int startTimestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(startTimestamp);
    return '${date.month}/${date.day}';
  }

  String getEndDate(int endTimestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(endTimestamp);
    return '${date.month}/${date.day}';
  }

  double getCurrentPercentage(int startTimeStamp, int endTimestamp) {
    var temp1 = endTimestamp - startTimeStamp;
    var temp2 = DateTime.now().millisecondsSinceEpoch - startTimeStamp;

    if (temp2 < 0) return 0;
    var ratio = temp2 / temp1;
    if (ratio > 1) return 1;
    return ratio;
  }

  Target? getLatestTarget() {
    Target? latestTarget;
    List<Target> passedTargets = [];
    List<Target> activeTargets = [];

    for (int i = 0; i < allTargets.length; i++) {
      if (isTargetPassed(allTargets[i]))
        passedTargets.add(allTargets[i]);
      else
        activeTargets.add(allTargets[i]);
    }

    if (activeTargets.isNotEmpty) {
      int min = -1;
      for (int i = 0; i < activeTargets.length; i++) {
        if ((DateTime.now().millisecondsSinceEpoch - activeTargets[i].startTimestamp!.toInt()) < min || i == 0) {
          latestTarget = activeTargets[i];
          min = (DateTime.now().millisecondsSinceEpoch - activeTargets[i].startTimestamp!.toInt());
        }
      }
      return latestTarget;
    }
    return null;
  }

  bool isTargetPassed(Target target) {
    if (target.endTimestamp! < DateTime.now().millisecondsSinceEpoch) return true;
    return false;
  }
}
