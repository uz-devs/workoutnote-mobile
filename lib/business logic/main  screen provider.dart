
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';

class MainScreenProvider extends ChangeNotifier{


  List<WorkOut> _workOuts = [];



  Future<void> fetchWorkOuts(String sessionKey, int  timestamp) async {

    if(_workOuts.isNotEmpty) _workOuts.clear();
   try {
     var response = await  WebServices.fetchWorkOuts(sessionKey, timestamp);
     print(sessionKey);

     if(response.statusCode == 200){
        print( json.decode(utf8.decode(response.bodyBytes)));
       var  workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        print(workoutsResponse);

       if(workoutsResponse.success){

       print  ("ivfhuiohbio");
         print(workoutsResponse.workouts);
        _workOuts.addAll(workoutsResponse.workouts);
        notifyListeners();

       }
     }
   }
   catch(e){
     print(e);
   }

  }

  Future<void> fecthExercises()async{
    var  response = await WebServices.fetchExercises();
    print(response.body);
    print(response.statusCode);

  }

  List<WorkOut> get workOuts => _workOuts;
}