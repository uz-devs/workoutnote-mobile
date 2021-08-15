import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutnote/providers/home%20%20%20screen%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/utils.dart';

class CalendarScreen extends StatefulWidget {
  final height;

  CalendarScreen(this.height);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}



class _CalendarScreenState extends State<CalendarScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<MainScreenProvider>(context, listen: true);



    return Container(

        child: ListView.builder(
            itemCount: calendarProvider.calendarWorkouts.isNotEmpty ? calendarProvider.calendarWorkouts.length + 2 : 2,
            itemBuilder: (ctx, index) {
              if (index == 0)
                return Container(
                  color: Colors.white,
                  child: TableCalendar(

                    headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontWeight: FontWeight.bold),
                        weekdayStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontWeight: FontWeight.bold)),
                    calendarStyle: CalendarStyle(

                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: Colors.red),
                        selectedDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green, width: 2), color: Colors.white),
                        selectedTextStyle: TextStyle(color: Colors.black),
                        todayDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color.fromRGBO(102, 51, 204, 1), width: 2), color: Colors.white),
                        todayTextStyle: TextStyle(color: Colors.black)),
                    firstDay: DateTime.utc(2015, 08, 07),
                    lastDay: DateTime.utc(2025, 08, 07),
                    focusedDay: DateTime.now(),
                    onDaySelected: (selectedDay, focusDay) async {
                      print(selectedDay);
                      print(focusDay);
                      setState(() {
                        calendarProvider.selectedDate = selectedDay;
                      });


                      var fromTimeStamp = DateTime(selectedDay.year,  selectedDay.month,  selectedDay.day).millisecondsSinceEpoch;
                      var tillTimeStamp = DateTime(selectedDay.year,  selectedDay.month,  selectedDay.day+1).millisecondsSinceEpoch-1;
                      print("from timestamp: $fromTimeStamp");
                      print("till timestamp: $tillTimeStamp");

                       await  calendarProvider.fetchWorkOutsByDate(userPreferences!.getString("sessionKey") ?? "", fromTimeStamp, tillTimeStamp);
                    },
                    selectedDayPredicate: (day) {
                      return calendarProvider.selectedDate == day;
                    },
                  ),
                );

              else if (index == 1){
                return  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "${DateFormat("yyyy.MM.dd").format(calendarProvider.selectedDate??DateTime.now())}, ${DateFormat("EEEE").format(calendarProvider.selectedDate??DateTime.now())}",
                      style: TextStyle(fontSize: 25, color: Color.fromRGBO(102, 51, 204, 1)),
                    ));
              }
              else {
                index = index - 2;
                  return WorkOutNote(widget.height, calendarProvider.calendarWorkouts[index], 2);
              }
            }));
  }
}
