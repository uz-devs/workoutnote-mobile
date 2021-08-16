import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/home%20%20%20screen%20provider.dart';
import 'package:workoutnote/ui/widgets/all%20%20workouts%20dialog.dart';
import 'package:workoutnote/ui/widgets/search%20dialog.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class CreateWorkOutCard extends StatelessWidget {
  final width;
  final height;
  List<WorkOut> workOuts;
  List<WorkOut> calendarWorkouts;
  var configProvider = ConfigProvider();
  var mainScreenProvider = MainScreenProvider();

  CreateWorkOutCard(this.width, this.height, this.workOuts, this.calendarWorkouts);

  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(bottom: 50.0),
      child: Consumer<CreateWorkoutProvider>(builder: (context, createWorkoutProvider, child) {
        int count = createWorkoutProvider.selectedLifts.length + 7;
        createWorkoutProvider.restoreTimer();
        createWorkoutProvider.restoreAllExercises();
        return Container(
          margin: EdgeInsets.all(10),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Container(margin: EdgeInsets.only(top: 10), child: _buildListView(count, createWorkoutProvider))),
        );
      }),
    );
  }

  Future<void> _showExercisesDialog(BuildContext context, ConfigProvider configProvider, CreateWorkoutProvider exProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SearchDialog(height);
        }).then((value) {
      exProvider.unselectedExercise = value as Exercise;
    });
  }

  Future<void> _showFavoriteWorkoutsDialog(BuildContext context, ConfigProvider configProvider, CreateWorkoutProvider exProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AllWorkoutsDialog();
        });
  }

  Widget _buildListView(int count, CreateWorkoutProvider exProvider) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) {
          if (index > 4 && index != count - 2)
            return Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                height: 1,
                color: Colors.black54,
              ),
            );
          else
            return Divider(
              height: 0,
              color: Colors.white,
            );
        },
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == 0)
            return Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ));
          else if (index == 1)
            return Container(
              margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10),
              child: TextFormField(
                onChanged: (c) async {
                  await exProvider.saveTitleToSharedPreference(c);
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 5.0),
                  hintText: "${title[configProvider.activeLanguage()]}",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                  ),
                ),
                controller: exProvider.titleContoller,
              ),
            );
          else if (index == 2) {
            return Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 15.0),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "${exProvider.hrs}:${exProvider.mins}:${exProvider.secs}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36, color: Color.fromRGBO(102, 51, 204, 1)),
                    ),
                  ),
                  Spacer(),
                  if (exProvider.timerSubscription != null || ((exProvider.secs.isNotEmpty && exProvider.secs != "00" || exProvider.hrs.isNotEmpty && exProvider.hrs != "00" || exProvider.mins.isNotEmpty && exProvider.mins != "00")))
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: IconButton(
                          onPressed: () {
                            exProvider.stopTimer();
                          },
                          icon: Icon(
                            Icons.stop_circle_outlined,
                            color: Color.fromRGBO(102, 51, 204, 1),
                            size: 50,
                          )),
                    ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                    child: (exProvider.timerSubscription == null || exProvider.timerSubscription!.isPaused)
                        ? IconButton(
                            onPressed: () {
                              if (exProvider.timerSubscription == null) {
                                print("start timer");

                                exProvider.startTimer();
                              } else if (exProvider.timerSubscription!.isPaused) {
                                exProvider.resumeTimer();
                              }
                            },
                            icon: Icon(
                              Icons.play_circle_outline,
                              color: Color.fromRGBO(102, 51, 204, 1),
                              size: 50,
                            ))
                        : IconButton(
                            onPressed: () {
                              exProvider.pauseTimer();
                            },
                            icon: Icon(
                              Icons.pause_circle_outline,
                              color: Color.fromRGBO(102, 51, 204, 1),
                              size: 50,
                            )),
                  ),
                ],
              ),
            );
          } else if (index == 3) {
            return Container(
              margin: EdgeInsets.only(left: 20.0, top: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  color: Color.fromRGBO(102, 51, 204, 1),
                  onPressed: () async {
                    await _showFavoriteWorkoutsDialog(context, configProvider, exProvider);
                  },
                  textColor: Colors.white,
                  child: Text("${seeExercises[configProvider.activeLanguage()]}"),
                ),
              ),
            );
          } else if (index == 4) {
            return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(231, 223, 247, 1),
                    border: Border.all(
                      color: Color.fromRGBO(230, 230, 250, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: _buildExerciseListItem("No.", "${exercisesName[configProvider.activeLanguage()]}", "KG", "REP", "RM", Color.fromRGBO(102, 51, 204, 1), 1, exProvider, index, context, configProvider));
          } else if (index == count - 2) {
            return Container(
                padding: EdgeInsets.only(left: 10, right: 10.0),
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: _buildExerciseListItem("", "${exProvider.unselectedExercise == null ? "운동 이름" : exProvider.unselectedExercise!.name}(${(exProvider.unselectedExercise == null ? "" : exProvider.unselectedExercise!.bodyPart)})", "KG", "REP",
                    "RM", Colors.grey, 3, exProvider, index, context, configProvider));
          } else if (index > 4 && index < count - 2 && index < count - 1) {
            index = index - 5;
            return Container(
                padding: EdgeInsets.only(left: 10, right: 10.0),
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: _buildExerciseListItem((index + 1).toString(), "${exProvider.selectedLifts[index].exerciseName}(${exProvider.selectedLifts[index].bodyPart})", "0.0", "0.0", exProvider.selectedLifts[index].rm.toString(), Colors.black, 2,
                    exProvider, index, context, configProvider));
          } else
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    width: 100,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      color: Color.fromRGBO(102, 51, 204, 1),
                      onPressed: () async {
                        exProvider.removeExercises();
                        await exProvider.saveListToSharePreference();
                      },
                      textColor: Colors.white,
                      child: Text("${remove[configProvider.activeLanguage()]}"),
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      color: Color.fromRGBO(102, 51, 204, 1),
                      onPressed: () async {
                        exProvider.createWorkOutSession(userPreferences!.getString("sessionKey") ?? "", exProvider.titleContoller.text, DateTime.now().microsecondsSinceEpoch, workOuts, calendarWorkouts).then((value) {
                          mainScreenProvider.update();
                        });
                        await exProvider.saveListToSharePreference();
                      },
                      textColor: Colors.white,
                      child: Text("${save[configProvider.activeLanguage()]}"),
                    ),
                  ),
                ],
              ),
            );
        });
  }

  Widget _buildExerciseListItem(String exerciseNumber, String exerciseName, String kg, String rep, String rm, Color color, int mode, CreateWorkoutProvider mainScreenProvider, int index, BuildContext context, ConfigProvider configProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            child: Text(
              exerciseNumber,
              style: TextStyle(color: color),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async {
              if (mode == 1) {
              } else if (mode == 2) {
                mainScreenProvider.unselectedExercise =
                    Exercise(mainScreenProvider.selectedLifts[index].exerciseId, mainScreenProvider.selectedLifts[index].exerciseName, mainScreenProvider.selectedLifts[index].bodyPart, "", false, NameTranslation(""));
              } else {
                await _showExercisesDialog(context, configProvider, mainScreenProvider);
              }
            },
            child: Container(
              child: Text(
                exerciseName,
                style: TextStyle(color: color),
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 2,
          child: mode == 2
              ? DropdownButton<int>(
                  isExpanded: true,
                  underline: SizedBox(),
                  iconSize: 0.0,
                  value: mainScreenProvider.selectedLifts[index].mass,
                  onChanged: (newValue) {
                    mainScreenProvider.updateMass(index, newValue!);
                  },
                  items: mainScreenProvider.selectedLifts[index].kgs.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: configProvider.measureMode == KG ? Text("$value") : Text("${configProvider.getConvertedMass(value.toDouble())}"),
                    );
                  }).toList(),
                )
              : mode == 1
                  ? InkWell(
                      onTap: () {
                        configProvider.changeMeasurement();
                      },
                      child: Text(
                        configProvider.measureMode == KG ? "KG" : "LBS",
                        style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    )
                  : Text(
                      "KG",
                      style: TextStyle(color: Colors.grey),
                    ),
        ),
        Expanded(
          flex: 2,
          child: mode == 2
              ? DropdownButton<int>(
                  isExpanded: true,
                  underline: SizedBox(),
                  iconSize: 0.0,
                  value: mainScreenProvider.selectedLifts[index].rep,
                  onChanged: (newValue) {
                    mainScreenProvider.updateRep(index, newValue!);
                  },
                  items: mainScreenProvider.selectedLifts[index].reps.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
                )
              : Text(
                  "REP",
                  style: TextStyle(color: mode == 1 ? Color.fromRGBO(102, 51, 204, 1) : Colors.grey),
                ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Text(
               mode != 2?   rm.toString():configProvider.getConvertedRM(double.parse(rm)).toString(),
              style: TextStyle(color:color),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: mode == 1
              ? Container()
              : (mode == 2
                  ? IconButton(
                      onPressed: () async {
                        mainScreenProvider.updateExercise(index);
                        mainScreenProvider.saveListToSharePreference();
                      },
                      icon: mainScreenProvider.selectedLifts[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Color.fromRGBO(102, 51, 204, 1),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.grey,
                            ))
                  : IconButton(
                      onPressed: () async {
                        if (mainScreenProvider.unselectedExercise != null) {
                          mainScreenProvider.addExercise(EditableLift.create(mainScreenProvider.unselectedExercise!.name, mainScreenProvider.unselectedExercise!.id, mainScreenProvider.unselectedExercise!.bodyPart, 1, 1, 1.0, true));
                          await mainScreenProvider.saveListToSharePreference();
                        } else
                          showToast("Please, select exercise!");
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                        size: 30,
                      ),
                    )),
        )
      ],
    );
  }
}
