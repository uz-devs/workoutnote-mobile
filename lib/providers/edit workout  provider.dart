


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';

class EditWorkoutProvider extends ChangeNotifier{


  List<EditableLift> existingLifts =  [];
  TextEditingController titleController = TextEditingController();
  List<EditableLift> addedLifts = [];
  Exercise? unselectedExercise;

 void  editWorkoutSession(WorkOut workOut){
    //TODO ge body part from exercise id
   titleController.text = workOut.title??"";
   for(int i = 0; i<workOut.lifts!.length; i++){
     existingLifts.add(EditableLift.create(workOut.lifts![i].exerciseName, workOut.lifts![i].exerciseId, "_bodyPart", workOut.lifts![i].liftMas!.toInt(), workOut.lifts![i].repetitions??0, workOut.lifts![i].oneRepMax??0, true, workOut.lifts![i].liftId));
   }
   notifyListeners();

 }
  void addExercise(EditableLift exercise) {
    addedLifts.add(exercise);

  }



}



