


import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';

class EditWorkoutProvider extends ChangeNotifier{

 List<Map<EditableLift, LIFT_STATUS>> lifts = [];

 Future<bool> editWorkoutSession() async{

   return true;

 }



}

enum LIFT_STATUS{
  EDIT,
  DELETE,
  ADD
}