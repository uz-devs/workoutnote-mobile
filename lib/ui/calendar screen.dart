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

  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context, listen: true);

    return Container(
        child: ListView.builder(itemCount: calendarProvider.workOuts.length +1,  itemBuilder: (ctx, index) {
      if(index == 0)
        return TableCalendar(
          firstDay: DateTime.utc(2021, 08, 06),
          lastDay: DateTime.utc(2030, 3, 14),
          rowHeight: 40,
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday ||day.weekday == DateTime.saturday ) {
                final text = DateFormat.E().format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
          focusedDay: DateTime.now(),
          onDaySelected: (selectedDay, focusDay) {
             calendarProvider.fetchWorkOutsBYDate(userPreferences!.getString("sessionKey")??"", selectedDay.millisecondsSinceEpoch);
          },
        );
      else  {
        return WorkOutNote(widget.height, calendarProvider.workOuts[index]);}
    })


    );
  }
}
