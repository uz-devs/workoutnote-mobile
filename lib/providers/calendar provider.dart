

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class CalendarProvider extends ChangeNotifier{
 List<WorkOut> _workOuts = [];
 int _responseCode1 = 0;
 bool _requestDone1 = false;

 Future<void> fetchWorkOutsBYDate(String sessionKey, int timestamp) async {
   if(_workOuts.isNotEmpty) _workOuts.clear();
   try {
     var response = await WebServices.fetchWorkOuts(sessionKey, timestamp);
     print(sessionKey);

     if (response.statusCode == 200) {
       var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
       if (workoutsResponse.success) {
         _workOuts.addAll(workoutsResponse.workouts);
         _responseCode1 = SUCCESS;
         notifyListeners();
       }
     }
   } on TimeoutException catch (e) {
     _responseCode1 = TIMEOUT_EXCEPTION;
     print(e);
   } on SocketException catch (e) {
     _responseCode1 = SOCKET_EXCEPTION;
     print(e);
   } on Error catch (e) {
     _responseCode1 = MISC_EXCEPTION;
     print(e);
   }
 }

 List<WorkOut> get workOuts => _workOuts;

 void reset(){
   _workOuts.clear();
    _responseCode1 = 0;
    _requestDone1 = false;

 }
}
