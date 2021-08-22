import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';

class CalendarScreen extends StatefulWidget {
  final height;

  CalendarScreen(this.height);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var calendarProvider = MainScreenProvider();
  var decoration1 = BoxDecoration();
  var decoration2 = BoxDecoration(
    border: Border.all(
      color: Color.fromRGBO(102, 51, 204, 1),
    ),
    borderRadius: BorderRadius.circular(50.0),
  );
  var decoration3 = BoxDecoration(
    color: Color.fromRGBO(102, 51, 204, 1),
    border: Border.all(
      color:Color.fromRGBO(102, 51, 204, 1),
    ),
    borderRadius: BorderRadius.circular(50.0),
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calendarProvider = Provider.of<MainScreenProvider>(context, listen: true);

    if (!calendarProvider.requestDone3) {
      calendarProvider.fetchCalendarWorkoutSessions().then((value) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<WorkOut> showWorkOuts = [];
    calendarProvider.updateWorkoutDates(calendarProvider.calendarWorkouts);
    for (int i = 0; i < calendarProvider.calendarWorkouts.length; i++) {
      if (calendarProvider.workOutDates[i] == "${calendarProvider.selectedDate!.year}.${calendarProvider.selectedDate!.month}.${calendarProvider.selectedDate!.day}") {
        showWorkOuts.add(calendarProvider.calendarWorkouts[i]);
      }
    }

    return Container(child: _buildItemsList(showWorkOuts));
  }

  Widget _buildItemsList(List<WorkOut> showWorkOuts) {
    return ListView.builder(
        itemCount: showWorkOuts.isNotEmpty ? showWorkOuts.length + 2 : 2,
        itemBuilder: (ctx, index) {
          if (index == 0)
            return Container(
              color: Colors.white,
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontWeight: FontWeight.bold), weekdayStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontWeight: FontWeight.bold)),
                calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,


                    todayTextStyle: TextStyle(color: Colors.black)),
                firstDay: DateTime.utc(2015, 08, 07),
                lastDay: DateTime.utc(2100, 08, 07),
                focusedDay: DateTime.now(),
                calendarBuilders: CalendarBuilders(
                  prioritizedBuilder: (context, day, focusedDay) {
                    var isDaySelected = calendarProvider.selectedDate!.year == day.year && calendarProvider.selectedDate!.month == day.month && calendarProvider.selectedDate!.day == day.day;
                    var isDayToday = DateTime.now().day == day.day && DateTime.now().month == day.month && DateTime.now().year == day.year;

                    if (calendarProvider.workOutDates.contains("${day.year}.${day.month}.${day.day}"))
                      return Column(
                        children: [
                          Container(
                              width: 25,
                              height: 25,
                              decoration: isDaySelected
                                  ? isDayToday
                                      ? decoration3
                                      : decoration2
                                  : isDayToday
                                      ? decoration3
                                      : decoration1,
                              child: Text(
                                "${day.day}",
                                style: TextStyle(fontWeight: FontWeight.bold,  color: isDayToday?Colors.white:Colors.black),
                                textAlign: TextAlign.center,
                              )),
                          Icon(
                            Icons.circle,
                            size: 10.0,
                            color: Color.fromRGBO(102, 51, 204, 1),
                          )
                        ],
                      );

                    return Column(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: isDaySelected
                              ? isDayToday
                                  ? decoration3
                                  : decoration2
                              : isDayToday
                                  ? decoration3
                                  : decoration1,
                          child: Text(

                            "${day.day}",
                            style: TextStyle(
                                color: isDayToday?Colors.white:Colors.black
                            ),
                            textAlign: TextAlign.center,

                          ),
                        ),
                      ],
                    );
                  },
                ),
                onDaySelected: (selectedDay, focusDay) async {
                  setState(() {
                    calendarProvider.selectedDate = selectedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  return calendarProvider.selectedDate == day;
                },
              ),
            );
          else if (index == 1) {
            return Container(
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  "${DateFormat("yyyy.MM.dd").format(calendarProvider.selectedDate ?? DateTime.now())}, ${DateFormat("EEEE").format(calendarProvider.selectedDate ?? DateTime.now())}",
                  style: TextStyle(fontSize: 25, color: Color.fromRGBO(102, 51, 204, 1)),
                ));
          } else {
            index = index - 2;
            return WorkOutNote(widget.height, showWorkOuts[index], 2);
          }
        });
  }
}
