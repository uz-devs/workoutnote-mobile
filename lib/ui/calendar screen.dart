import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutnote/business%20logic/calendar%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/utils.dart';

class CalendarScreen extends StatefulWidget {
  final height;
   CalendarScreen(this.height);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {


  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context, listen: true);

    return Container(
        child: ListView.builder(itemCount: calendarProvider.workOuts.isNotEmpty?calendarProvider.workOuts.length +2:3,  itemBuilder: (ctx, index) {
      if(index == 0)
        return TableCalendar(
          firstDay: DateTime.utc(2020, 08, 07),
          lastDay: DateTime.utc(2030, 3, 14),
          rowHeight: 40,
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context,  day,  focusedDay){
              return Center(
                child: Container(


                  height: 20,
                  width: 20,
                  color: Colors.deepPurpleAccent,
                  child: Text(
                    "${focusedDay.day}", style: TextStyle(

                    color: Colors.white,

                  ),),),
              );
            } ,
            dowBuilder: (context, day) {if (day.weekday == DateTime.sunday ||day.weekday == DateTime.saturday ) {
                final text = DateFormat.E().format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }},
            selectedBuilder: (context, day, focusedDay){
              print("graergreth");
              print(day);
              print(focusedDay);

              return Container(
               color: Colors.deepPurpleAccent,
                child: Text("$focusedDay"),
              );

            }
          ),
          focusedDay: selectedDay??DateTime.now(),
          onDaySelected: (selectedDay, focusDay) {

             calendarProvider.fetchWorkOutsBYDate(userPreferences!.getString("sessionKey")??"", selectedDay.millisecondsSinceEpoch).then((value) {
               setState(() {
                 selectedDay = selectedDay;
               });
             });


             },
        );
      else  if(index == 1)
        return Divider(thickness: 5, color: Colors.deepPurpleAccent.withOpacity(0.5),);
      else  {
        if(calendarProvider.workOuts.isNotEmpty) {
          index = index - 2;
          return WorkOutNote(widget.height, calendarProvider.workOuts[index]);
        }
      else return Center(child: Text("No workouts to show", style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent
        ),),);
      }
    })


    );
  }

}
