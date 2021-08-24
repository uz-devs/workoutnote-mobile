import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class EditWorkoutProvider extends ChangeNotifier {
  //region vars
  List<EditableLift> existingLifts = [];
  List<EditableLift> liftsToStore = [];
  List<EditableLift> updatedList = [];
  TextEditingController titleController = TextEditingController();
  Exercise? _unselectedExercise;
  bool done = false;
  String message = "success";

  //endregion

  void getLiftsFromWorkoutSession(WorkOut workOut) {
    titleController.text = workOut.title ?? "";
    for (int i = 0; i < workOut.lifts!.length; i++) {
      existingLifts.add(EditableLift.create(workOut.lifts![i].exerciseName, workOut.lifts![i].exerciseId, "_bodyPart", workOut.lifts![i].liftMas!.toInt(), workOut.lifts![i].repetitions ?? 0, workOut.lifts![i].oneRepMax ?? 0, true, workOut.lifts![i].liftId));
      liftsToStore.add(EditableLift.create(workOut.lifts![i].exerciseName, workOut.lifts![i].exerciseId, "_bodyPart", workOut.lifts![i].liftMas!.toInt(), workOut.lifts![i].repetitions ?? 0, workOut.lifts![i].oneRepMax ?? 0, true, workOut.lifts![i].liftId));
      done = true;
    }
  }

  Future<void> editWorkout(WorkOut workOut) async {
    var sessionKey = userPreferences!.getString("sessionKey") ?? "";
    bool canEditSession = false;
    for (int i = 0; i < existingLifts.length; i++) {
      if (existingLifts[i].isSelected) {
        canEditSession = true;
        break;
      }
    }
    if (canEditSession) {
      updatedList.addAll(existingLifts);

      for (int i = 0; i < updatedList.length; i++) {
        print(updatedList[i].exerciseName);
      }
      try {
        var updateWorkoutResponse = await WebServices.updateMyWorkout(sessionKey, workOut.id ?? -1, titleController.text, workOut.duration ?? 0);
        if (updateWorkoutResponse.statusCode == 200 && jsonDecode(updateWorkoutResponse.body)["success"]) {
          for (int i = 0; i < existingLifts.length; i++) {
            if (!existingLifts[i].isSelected) {
              var removeResponse = await WebServices.removeMyLift(sessionKey, workOut.id ?? -1, existingLifts[i].liftId ?? -1);

              if (removeResponse.statusCode == 200 && jsonDecode(removeResponse.body)["success"]) {
                updatedList.removeWhere((element) => element.liftId == existingLifts[i].liftId);
              }
            }
            else {
              if (existingLifts[i].liftId == -1) {
                var addResponse = await WebServices.insertLift(sessionKey, DateTime.now().millisecondsSinceEpoch, existingLifts[i].mass, existingLifts[i].exerciseId ?? -1, workOut.id ?? -1, existingLifts[i].rep, existingLifts[i].rm);

                if (addResponse.statusCode == 200 && jsonDecode(addResponse.body)["success"]) {

                  print("added");
                  print(jsonDecode(addResponse.body)["lift"]["id"]);
                  existingLifts[i].liftId = jsonDecode(addResponse.body)["lift"]["id"];
                }
              }
              else {
                for (int j = 0; j < liftsToStore.length; j++) {
                  if (existingLifts[i].liftId == liftsToStore[j].liftId) {
                    if (existingLifts[i].exerciseName != liftsToStore[j].exerciseName || existingLifts[i].mass != liftsToStore[j].mass || existingLifts[i].rep != liftsToStore[j].rep) {
                      await WebServices.updateMyLift(sessionKey, workOut.id ?? -1, existingLifts[i].liftId ?? -1, existingLifts[i].exerciseId ?? -1, existingLifts[i].mass, existingLifts[i].rep);
                    }
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        print(e);
        message = "fail";
      }
    } else {
      showToast("You need to add at least one exercise for one workout session!");
      message = "fail";

    }
  }



  void updateAllWorkOutLists(WorkOut workOut, MainScreenProvider mainScreenProvider, BuildContext context,  String successMessage) {
    editWorkout(workOut).then((value) {


      if(message  != "fail") {
        for (int k = 0; k < mainScreenProvider.workOuts.length; k++) {
          if (mainScreenProvider.workOuts[k].id == workOut.id) {
            mainScreenProvider.workOuts[k].lifts!.clear();
            mainScreenProvider.workOuts[k].title = titleController.text;
            for (int i = 0; i < updatedList.length; i++) {
              mainScreenProvider.workOuts[k].lifts!.add(Lift.create(
                  updatedList[i].liftId,
                  0,
                  updatedList[i].rm,
                  updatedList[i].exerciseId,
                  updatedList[i].exerciseName,
                  updatedList[i].mass.toDouble(),
                  updatedList[i].rep));
            }
          }
        }

        if (mainScreenProvider.calendarWorkouts.isNotEmpty) {
          mainScreenProvider.calendarWorkouts
              .where((element) => element.id == workOut.id)
              .single
              .lifts!
              .clear();
          mainScreenProvider.calendarWorkouts
              .where((element) => element.id == workOut.id)
              .single
              .title = titleController.text;
          for (int i = 0; i < updatedList.length; i++) {
            mainScreenProvider.calendarWorkouts
                .where((element) => element.id == workOut.id)
                .single
                .lifts!
                .add(Lift.create(
                updatedList[i].liftId,
                0,
                updatedList[i].rm,
                updatedList[i].exerciseId,
                updatedList[i].exerciseName,
                updatedList[i].mass.toDouble(),
                updatedList[i].rep));
          }
        }

        mainScreenProvider.update();
        showToast(successMessage);

        Navigator.pop(context);
      }
    });
  }

  //region lifts: add, update,  remove
  void updateLiftActiveStatus(int index) {
    if (!existingLifts[index].isSelected)
      existingLifts[index].isSelected = true;
    else if (existingLifts[index].isSelected) existingLifts[index].isSelected = false;
    notifyListeners();
  }

  void updateLiftExercise(Exercise exercise, int index) {
    existingLifts[index].exerciseName = exercise.name;
    existingLifts[index].exerciseId = exercise.id;
    notifyListeners();
  }

  void removeLifts() {
    existingLifts.removeWhere((element) => element.isSelected);
    notifyListeners();
  }

  void addExercise(EditableLift lift) {
    existingLifts.add(lift);
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

  void reset() {
    existingLifts.clear();
    liftsToStore.clear();
    updatedList.clear();
    titleController = TextEditingController();
    _unselectedExercise = null;
    done = false;
  }
}
