import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class EditWorkoutProvider extends ChangeNotifier {
  //region vars
  List<EditableLift> existingLifts = [];
  List<EditableLift> liftsToStore = [];
  TextEditingController titleController = TextEditingController();
  Exercise? _unselectedExercise;
  bool done = false;

  //endregion

  void getLiftsFromWorkoutSession(WorkOut workOut) {
    //TODO ge body part from exercise id
    titleController.text = workOut.title ?? "";
    for (int i = 0; i < workOut.lifts!.length; i++) {
      existingLifts.add(EditableLift.create(workOut.lifts![i].exerciseName, workOut.lifts![i].exerciseId, "_bodyPart", workOut.lifts![i].liftMas!.toInt(), workOut.lifts![i].repetitions ?? 0, workOut.lifts![i].oneRepMax ?? 0, true, workOut.lifts![i].liftId));
      liftsToStore.add(EditableLift.create(workOut.lifts![i].exerciseName, workOut.lifts![i].exerciseId, "_bodyPart", workOut.lifts![i].liftMas!.toInt(), workOut.lifts![i].repetitions ?? 0, workOut.lifts![i].oneRepMax ?? 0, true, workOut.lifts![i].liftId));
      done = true;
    }
  }

  Future<void> editWorkout(WorkOut workOut) async {
    var sessionKey = userPreferences!.getString("sessionKey") ?? "";

    var updateWorkoutResponse = await WebServices.updateMyWorkout(sessionKey, workOut.id ?? -1, titleController.text, workOut.duration ?? 0);

    if (updateWorkoutResponse.statusCode == 200 && jsonDecode(updateWorkoutResponse.body)["success"]) {
      for (int i = 0; i < existingLifts.length; i++) {
        if (existingLifts[i].liftId == -1 && existingLifts[i].isSelected) {
          var addResponse = await WebServices.insertLift(sessionKey, DateTime.now().millisecondsSinceEpoch, existingLifts[i].mass, existingLifts[i].exerciseId ?? -1, workOut.id ?? -1, existingLifts[i].rep, existingLifts[i].rm);
          if (addResponse.statusCode == 200) {
            print("hey");
          }
        } else if (existingLifts[i].liftId != -1 && !existingLifts[i].isSelected) {
          var removeResponse = await WebServices.removeMyLift(sessionKey, workOut.id ?? -1, existingLifts[i].liftId ?? -1);
          if (removeResponse.statusCode == 200) {
            print("exercise removed successfully");
          }
        } else if (existingLifts[i].liftId != -1 && existingLifts[i].isSelected) {
          for (int j = 0; j < liftsToStore.length; j++) {
            if (existingLifts[i].liftId == liftsToStore[j].liftId) {
              if (existingLifts[i].exerciseName != liftsToStore[j].exerciseName || existingLifts[i].mass != liftsToStore[j].mass || existingLifts[i].rep != liftsToStore[j].rep) {
                var updateResponse = await WebServices.updateMyLift(sessionKey, workOut.id ?? -1, existingLifts[i].liftId ?? -1, existingLifts[i].exerciseId ?? -1, existingLifts[i].mass, existingLifts[i].rep);
                if (updateResponse.statusCode == 200) {
                  print("success");
                  print(updateResponse.body);
                }
              }
            }
          }
        }
      }
    }

  }

  //region lifts: add, update,  remove
  void updateLiftActiveStatus(int index) {
    if (existingLifts[index].isSelected == false)
      existingLifts[index].isSelected = true;
    else
      existingLifts[index].isSelected = false;
    notifyListeners();
  }

  void updateLift(Exercise exercise, int index) {
    existingLifts[index].exerciseName = exercise.name;
    existingLifts[index].exerciseId = exercise.id;
    notifyListeners();
  }

  void removeLifts() {
    existingLifts.removeWhere((element) => element.isSelected);
    notifyListeners();
  }

  void addExercise(EditableLift exercise) {
    existingLifts.add(exercise);
    notifyListeners();
  }

  //endregion

  //region update mass,rep,RM
  void updateMass(int index, int val) {
    existingLifts[index].mass = val;
    updateRM(val, existingLifts[index].rep, index);
    notifyListeners();
  }

  void updateRep(index, int val) {
    existingLifts[index].rep = val;
    updateRM(existingLifts[index].mass, val, index);
    notifyListeners();
  }

  void updateRM(int mass, int rep, index) {
    existingLifts[index].rm = roundDouble((mass + mass * rep * 0.025), 2);
  }

//endregion

  //region getters&setters
  Exercise? get unselectedExercise => _unselectedExercise;

  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

//endregion

//region

  void reset() {
    existingLifts = [];
    liftsToStore = [];
    titleController = TextEditingController();
    _unselectedExercise = null;
    done = false;
  }
}
