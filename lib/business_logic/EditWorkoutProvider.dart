import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/data/models/EditableLiftModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/models/WorkoutListModel.dart';
import 'package:workoutnote/data/services/Network.dart';


import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'ConfigProvider.dart';
import 'WorkoutListProvider.dart';

class EditWorkoutProvider extends ChangeNotifier {
  //region vars
  List<EditableLift> existingLifts = [];
  List<EditableLift> liftsToStore = [];
  List<EditableLift> updatedList = [];
  TextEditingController titleController = TextEditingController();
  EditableLift? _unselectedExercise = EditableLift();

  //endregion

  void getLiftsFromWorkoutSession(WorkOut workOut) {
    titleController.text = workOut.title ?? '';
    for (int i = 0; i < workOut.lifts!.length; i++) {
      existingLifts.add(EditableLift.create(
          workOut.lifts![i].exerciseName,
          workOut.lifts![i].exerciseId,
          '_bodyPart',
          workOut.lifts![i].liftMas!.toInt(),
          workOut.lifts![i].repetitions ?? 0,
          workOut.lifts![i].oneRepMax ?? 0,
          true,
          workOut.lifts![i].liftId));

      liftsToStore.add(EditableLift.create(
          workOut.lifts![i].exerciseName,
          workOut.lifts![i].exerciseId,
          '_bodyPart',
          workOut.lifts![i].liftMas!.toInt(),
          workOut.lifts![i].repetitions ?? 0,
          workOut.lifts![i].oneRepMax ?? 0,
          true,
          workOut.lifts![i].liftId));
    }
  }

  Future<void> editWorkout(WorkOut workOut, ConfigProvider configProvider) async {
    var sessionKey = userPreferences!.getString('sessionKey') ?? '';
    bool canEditSession = false;
    for (int i = 0; i < existingLifts.length; i++) {
      if (existingLifts[i].isSelected) {
        canEditSession = true;
        break;
      }
    }
    if (canEditSession) {
      updatedList.addAll(existingLifts);

      try {
        var updateWorkoutResponse = await WebServices.updateMyWorkout(
            sessionKey,
            workOut.id ?? -1,
            titleController.text,
            workOut.duration ?? 0);
        if (updateWorkoutResponse.statusCode == 200 &&
            jsonDecode(updateWorkoutResponse.body)['success']) {
          for (int i = 0; i < existingLifts.length; i++) {
            if (!existingLifts[i].isSelected) {
              var removeResponse = await WebServices.removeMyLift(
                  sessionKey, workOut.id ?? -1, existingLifts[i].liftId ?? -1);

              if (removeResponse.statusCode == 200 &&
                  jsonDecode(removeResponse.body)['success']) {
                updatedList.removeWhere(
                    (element) => element.liftId == existingLifts[i].liftId);
              }
            } else {
              if (existingLifts[i].liftId == -1) {
                var addResponse = await WebServices.insertLift(
                    sessionKey,
                    DateTime.now().millisecondsSinceEpoch,
                    existingLifts[i].mass,
                    existingLifts[i].exerciseId ?? -1,
                    workOut.id ?? -1,
                    existingLifts[i].rep,
                    existingLifts[i].rm);

                if (addResponse.statusCode == 200 &&
                    jsonDecode(addResponse.body)['success']) {
                  existingLifts[i].liftId =
                      jsonDecode(addResponse.body)['lift']['id'];
                }
              } else {
                for (int j = 0; j < liftsToStore.length; j++) {
                  if (existingLifts[i].liftId == liftsToStore[j].liftId) {
                    if (existingLifts[i].exerciseName !=
                            liftsToStore[j].exerciseName ||
                        existingLifts[i].mass != liftsToStore[j].mass ||
                        existingLifts[i].rep != liftsToStore[j].rep) {
                      await WebServices.updateMyLift(
                          sessionKey,
                          workOut.id ?? -1,
                          existingLifts[i].liftId ?? -1,
                          existingLifts[i].exerciseId ?? -1,
                          existingLifts[i].mass,
                          existingLifts[i].rep);
                    }
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      showToast('${noExerciseWarning[configProvider.activeLanguage()]}');
    }
  }

  void updateAllWorkOutLists(WorkOut workOut, MainScreenProvider mainScreenProvider, ConfigProvider configProvider, BuildContext context) {
    editWorkout(workOut, configProvider).then((value) {
      //update  today's  workouts locally

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

      //update  calendar workouts locally
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

      //update  favorite workouts locally
      for (int k = 0; k < mainScreenProvider.favoriteWorkOuts.length; k++) {
        if (mainScreenProvider.favoriteWorkOuts[k].id == workOut.id) {
          mainScreenProvider.favoriteWorkOuts[k].lifts!.clear();
          mainScreenProvider.favoriteWorkOuts[k].title = titleController.text;
          for (int i = 0; i < updatedList.length; i++) {
            mainScreenProvider.favoriteWorkOuts[k].lifts!.add(Lift.create(
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

      reset();
      mainScreenProvider.update();
      Navigator.pop(context);
    });
  }

  //region lifts: add, update,  remove
  void updateLiftActiveStatus(int index) {
    if (!existingLifts[index].isSelected)
      existingLifts[index].isSelected = true;
    else if (existingLifts[index].isSelected)
      existingLifts[index].isSelected = false;
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
  EditableLift? get unselectedExercise => _unselectedExercise;

  set unselectedExercise(EditableLift? value) {
    _unselectedExercise = value;
    notifyListeners();
  }


  void reorderList(int oldIndex,  int newIndex){
    if(newIndex > oldIndex){
      newIndex-=1;
    }
    final items =existingLifts.removeAt(oldIndex);
    existingLifts.insert(newIndex, items);
    notifyListeners();
  }




//endregion

  void reset() {
    existingLifts.clear();
    liftsToStore.clear();
    updatedList.clear();
    titleController = TextEditingController();
    _unselectedExercise = null;
    notifyListeners();
  }
}
