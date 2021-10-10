import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/data/models/BodyPartsModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/services/Network.dart';



import 'package:workoutnote/utils/utils.dart';

class ExercisesDialogProvider extends ChangeNotifier {
  //region vars
  List<Exercise> favoriteExercises = [];
  List<Exercise> allExercises = [];
  List<BodyPart> myBodyParts = [];
  List<Exercise> exercisesByBodyParts = [];
  int responseCode = LOADING;
  bool showFavorite = false;
  String activeBodyPart = '';
 //endregion
  //region api calls
  Future<void> fetchExercises() async {
    try {
      var response = await WebServices.fetchExercises();

      if (response.statusCode == 200) {
        var workoutsResponse = ExercisesResponse.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          allExercises.addAll(workoutsResponse.exercises ?? []);
          var response = await WebServices.fetchFavoriteExercises(
              userPreferences!.getString('sessionKey') ?? '');
          var execResponse = ExercisesResponse.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          if (execResponse.success) {
            responseCode = SUCCESS;
            favoriteExercises.addAll(execResponse.exercises ?? []);
            for (int i = 0; i < favoriteExercises.length; i++) {
              for (int j = 0; j < allExercises.length; j++) {
                if (allExercises[j].name == favoriteExercises[i].name) {
                  allExercises[j].isFavorite = true;
                  favoriteExercises[i].isFavorite = true;
                }
              }
            }
          }

          notifyListeners();
        }
      }
    } on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> fetchBodyParts() async {
    if (myBodyParts.isNotEmpty) myBodyParts.clear();
    try {
      var response = await WebServices.fetchBodyParts();

      if (response.statusCode == 200) {
        var bodyParts = BodyPartsResponse.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        myBodyParts.addAll(bodyParts.bodyParts??[]);
      }
    }  on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> setFavoriteExercise(String sessionKey, int exerciseId, Exercise exercise) async {
    try {
      var response =
          await WebServices.setMyFavoriteExercise(sessionKey, exerciseId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        _updateExerciseFavoriteStatus(exerciseId, 1);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unsetFavoriteExercise(String sessionKey, int exerciseId, Exercise exercise) async {
    try {
      var response =
          await WebServices.unsetMyFavoriteExercise(sessionKey, exerciseId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        _updateExerciseFavoriteStatus(exerciseId, 0);
      }
    } catch (e) {
      print(e);
    }
  }
  //endregion
  //region  utils
  void filterExercises(List<Exercise> showExercises) {
    if (showFavorite) {
      if (activeBodyPart.isNotEmpty) {
        for (int i = 0; i < favoriteExercises.length; i++) {
          if (favoriteExercises[i].bodyPart == activeBodyPart)
            showExercises.add(favoriteExercises[i]);
        }
      } else {
        showExercises.addAll(favoriteExercises);
      }
    } else {
      if (activeBodyPart.isNotEmpty) {
        for (int i = 0; i < allExercises.length; i++) {
          if (allExercises[i].bodyPart == activeBodyPart)
            showExercises.add(allExercises[i]);
        }
      } else {
        showExercises.addAll(allExercises);
      }
    }
  }

  void searchExercises(String searchWord, List<Exercise> showExercises) {
    List<Exercise> temps = [];
    if (searchWord.isNotEmpty) {
      for (int i = 0; i < showExercises.length; i++) {
        if (showExercises[i].name!.contains(searchWord) ||  '${showExercises[i].namedTranslations!.english}'.contains(searchWord)) {
          temps.add(showExercises[i]);
        }
      }

      showExercises.clear();
      showExercises.addAll(temps);
    }
  }

  void _updateExerciseFavoriteStatus(int id, int rem) {
    if (showFavorite) {
      favoriteExercises.removeWhere((element) => element.id == id);
      for (int i = 0; i < allExercises.length; i++) {
        if (allExercises[i].id == id) allExercises[i].isFavorite = false;
      }
    } else {
      if (rem == 1) {
        for (int i = 0; i < allExercises.length; i++) {
          if (allExercises[i].id == id) allExercises[i].isFavorite = true;
        }
        favoriteExercises
            .addAll(allExercises.where((element) => element.id == id));
      }
      else {
        for (int i = 0; i < allExercises.length; i++) {
          if (allExercises[i].id == id) allExercises[i].isFavorite = false;
        }
        favoriteExercises.removeWhere((element) => element.id == id);
      }
    }
    notifyListeners();
  }

  void onBodyPartpressed(String bodyPart) {
    if (activeBodyPart.isEmpty || activeBodyPart != bodyPart) {
      activeBodyPart = bodyPart;
    } else if (activeBodyPart == bodyPart) {
      activeBodyPart = '';
    }
    notifyListeners();
  }

  void reset() {

    favoriteExercises.clear();
    allExercises.clear();
    myBodyParts.clear();
    exercisesByBodyParts.clear();
    responseCode = LOADING;
    showFavorite = false;
    activeBodyPart = '';
  }
  //endregion

}
