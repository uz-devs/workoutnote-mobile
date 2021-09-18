import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class CalendarScreen extends StatefulWidget {
  final height;

  CalendarScreen(this.height);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<String>? years = ["January", "February", "March", "April",  "May", "June", "July", "August", "September", "October", "November", "December"];
  var calendarProvider = MainScreenProvider();
  var configProvider = ConfigProvider();
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
      color: Color.fromRGBO(102, 51, 204, 1),
    ),
    borderRadius: BorderRadius.circular(50.0),
  );
  var decoration4 = BoxDecoration(

      color: Color.fromRGBO(245, 245, 245, 1));
  double? width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calendarProvider = Provider.of<MainScreenProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    if (!calendarProvider.requestDone3) {
      calendarProvider.fetchCalendarWorkoutSessions().then((value) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
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
    return SingleChildScrollView(
      reverse: true,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: showWorkOuts.isNotEmpty ? showWorkOuts.length + 3 : 3,
          itemBuilder: (ctx, index) {
            if (index == 0)
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: TableCalendar(
                  locale: configProvider.activeLanguage() == english ? "en_EN" : "ko_KR",
                  availableGestures: AvailableGestures.horizontalSwipe,
                  headerStyle: HeaderStyle(
                    titleCentered: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
                    formatButtonVisible: false,
                    rightChevronVisible: false,
                    leftChevronVisible: true,
                    leftChevronIcon: DropdownButton(
                      icon: Container(margin: EdgeInsets.only(left: 15.0), child: SvgPicture.asset("assets/icons/expand.svg")),
                      underline: SizedBox(),
                      value: years![6],
                      hint: Text("${years![8]}"),
                      onChanged: (item) {
                        setState(() {
                          // configProvider.selectedYear = item.toString();
                        });
                      },
                      items: years!.map((String year) {
                        return DropdownMenuItem<String>(value: year, child: Text("$year"));
                      }).toList(),
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(



                   //  decoration: decoration4,
                      weekendStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontSize: 13, fontWeight: FontWeight.bold),
                      weekdayStyle: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontSize: 12, fontWeight: FontWeight.bold)),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    todayTextStyle: TextStyle(color: Colors.black),
                  ),
                  firstDay: DateTime.utc(2021, 01, 01),
                  lastDay: DateTime.utc(2100, 08, 07),
                  focusedDay: calendarProvider.selectedDate ?? DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    prioritizedBuilder: (context, day, focusedDay) {
                      var isDaySelected = calendarProvider.selectedDate!.year == day.year && calendarProvider.selectedDate!.month == day.month && calendarProvider.selectedDate!.day == day.day;
                      var isDayToday = DateTime.now().day == day.day && DateTime.now().month == day.month && DateTime.now().year == day.year;

                      if (calendarProvider.workOutDates.contains("${day.year}.${day.month}.${day.day}"))
                        return Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10.0,
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
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
                                    style: TextStyle(fontWeight: FontWeight.bold, color: isDayToday ? Colors.white : Colors.black),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        );

                      return Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10.0,
                              color: Colors.transparent,
                            ),
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
                                style: TextStyle(color: isDayToday ? Colors.white : Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onDaySelected: (selectedDay, focusDay) async {
                    calendarProvider.fetchSingleNote(selectedDay.millisecondsSinceEpoch).then((value) {
                      setState(() {
                        calendarProvider.noteController.text = value;
                      });
                    });

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
                  color: Colors.white,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color.fromRGBO(170, 170, 170, 1),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${note[configProvider.activeLanguage()]}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                child: Icon(Icons.save, color: Color.fromRGBO(102, 51, 204, 1)),
                                onTap: () {
                                  calendarProvider.saveNote(calendarProvider.selectedDate!.millisecondsSinceEpoch, calendarProvider.noteController.text).then((value) {
                                    if (value) {
                                      showToast("Save  was successfull");
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        )),
                    Container(
                        height: 70,
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        margin: EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 20),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          border: Border.all(
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),

                        //scrollDirection: Axis.vertical,
                        child: TextFormField(
                          controller: calendarProvider.noteController,
                          // initialValue: calendarProvider.notes[index].values.single,
                          keyboardType: TextInputType.visiblePassword,

                          cursorColor: Color.fromRGBO(102, 51, 204, 1),
                          maxLines: 5,

                          decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                top: 5.0,
                              ),
                              hintText: "${title[configProvider.activeLanguage()]}",
                              hintStyle: TextStyle(fontSize: 16)),
                        )),
                  ]));
            } else if (index == 2) {
              return Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Text(
                    "${DateFormat(
                      "yyyy.MM.dd",
                      configProvider.activeLanguage() == english ? "en_EN" : "ko_KR",
                    ).format(calendarProvider.selectedDate ?? DateTime.now())}, ${DateFormat(
                      "EEEE",
                      configProvider.activeLanguage() == english ? "en_EN" : "ko_KR",
                    ).format(calendarProvider.selectedDate ?? DateTime.now()).substring(0, 3).toUpperCase()}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                  ));
            } else {
              index = index - 3;
              return WorkOutNote(widget.height, showWorkOuts[index], 2);
            }
          }),
    );
  }
}
