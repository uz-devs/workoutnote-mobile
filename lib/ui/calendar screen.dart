import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutnote/providers/calendar%20provider.dart';
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
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context, listen: true);

    return Container(
      margin: EdgeInsets.only(top: 10.0),
        child: ListView.builder(itemCount: calendarProvider.workOuts.isNotEmpty?calendarProvider.workOuts.length +2:3,  itemBuilder: (ctx, index) {
      if(index == 0)
        return TableCalendar(

          calendarStyle: CalendarStyle(
              outsideDaysVisible: false ,
              selectedDecoration: BoxDecoration(shape: BoxShape.circle, border:Border.all(color: Colors.red, width: 2), color: Colors.white), selectedTextStyle: TextStyle(color: Colors.black),
              todayDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color.fromRGBO(102, 51, 204, 1), width: 2),   color: Colors.white), todayTextStyle: TextStyle(color: Colors.black)),
          firstDay: DateTime.utc(2015, 08, 07),
          lastDay: DateTime.utc(2025, 08, 07),
          focusedDay: DateTime.now(),
          onDaySelected: (selectedDay, focusDay) {calendarProvider.fetchWorkOutsBYDate(userPreferences!.getString("sessionKey")??"", selectedDay.millisecondsSinceEpoch).then((value) {
               setState(() {
                 calendarProvider.selectedDate = selectedDay;
               });
             });
            },
          selectedDayPredicate: (day){
            return calendarProvider.selectedDate == day;
            },
        );
      else  if(index == 1)
        return Divider(thickness: 5, color: Color.fromRGBO(102, 51, 204, 0.5),);

      else  {
        if(calendarProvider.workOuts.isNotEmpty) {
          index = index - 2;
          return WorkOutNote(widget.height, calendarProvider.workOuts[index], 2);
        }
      else return Center(child: Text("No workouts to show", style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(102, 51, 204, 1)
        ),),);
      }
    })


    );
  }

}
