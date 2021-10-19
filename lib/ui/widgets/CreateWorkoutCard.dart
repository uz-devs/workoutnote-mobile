import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/CreateWorkoutSessionProvider.dart';
import 'package:workoutnote/business_logic/ExercisesListProvider.dart';
import 'package:workoutnote/business_logic/HomeProvider.dart';
import 'package:workoutnote/data/models/EditableLiftModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/models/WorkoutListModel.dart';

import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'ExercisesListDialog.dart';
import 'FavoriteWorkoutsDialog.dart';

class WorkoutCreatorWidget extends StatelessWidget {
  final width;
  final height;
  List<WorkOut> workOuts;
  List<WorkOut> calendarWorkouts;
  var configProvider = ConfigProvider();
  var mainScreenProvider = MainScreenProvider();
  var _createWorkOutProvider = CreateWorkoutProvider();
  var exerciseProvider = ExercisesDialogProvider();

  WorkoutCreatorWidget(this.width, this.height, this.workOuts, this.calendarWorkouts);

  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
    exerciseProvider = Provider.of<ExercisesDialogProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(bottom: 35.0),
      child: Consumer<CreateWorkoutProvider>(builder: (context, createWorkoutProvider, child) {
        if (createWorkoutProvider.unselectedExercise == null) {
          createWorkoutProvider.unselectedExercise = EditableLift();
        }
        _createWorkOutProvider = createWorkoutProvider;
        int count = 8;
        createWorkoutProvider.restoreTimer();
        return Container(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
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
    await showDialog(context: context, builder: (BuildContext context) => SearchDialog(height)).then((value) async {
      if (value != null) {
        Exercise exercise = value;
        exProvider.unselectedExercise = EditableLift.create(exercise.name, exercise.id, exercise.bodyPart, exProvider.unselectedExercise!.mass, exProvider.unselectedExercise!.rep, exProvider.unselectedExercise!.rm, false, -1);
        await exProvider.saveUnselectedExerciseToPreferences();
      }
    });
  }

  Future<void> _showFavoriteWorkoutsDialog(BuildContext context, ConfigProvider configProvider, CreateWorkoutProvider exProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AllWorkoutsDialog();
        });
  }

  Widget _buildReorderableListView(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(_createWorkOutProvider.selectedLifts.length, (index) {
        return Container(
            key: Key('$index'),
            padding: EdgeInsets.only(left: 10, right: 10.0),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                _buildExerciseListItem((index + 1).toString(), '${_createWorkOutProvider.getExerciseName(exerciseProvider, configProvider, _createWorkOutProvider.selectedLifts[index].exerciseId ?? -0)}', '0.0', '0.0', _createWorkOutProvider.selectedLifts[index].rm.toString(), Colors.black, 2, _createWorkOutProvider, index, context, configProvider, 'body'),
                Container(margin: EdgeInsets.only(left: 15.0, right: 15.0), child: Divider(height: 1, color: Color.fromRGBO(170, 170, 170, 1))),
              ],
            ));
      }),
      onReorder: _createWorkOutProvider.reorderList,
    );
  }

  Widget _buildListView(int count, CreateWorkoutProvider exProvider) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == 0)
            return Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '${DateFormat(
                    'yyyy.MM.dd',
                    configProvider.activeLanguage() == english ? 'en_EN' : 'ko_KR',
                  ).format(DateTime.now())}. ${DateFormat(
                    'EEEE',
                    configProvider.activeLanguage() == english ? 'en_EN' : 'ko_KR',
                  ).format(DateTime.now()).substring(0, configProvider.activeLanguage() == english ? 3 : 1).toUpperCase()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ));
          else if (index == 1)
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                ),
              ),
              margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10),
              child: TextFormField(
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Color.fromRGBO(102, 51, 204, 1),
                onChanged: (c) async {
                  await exProvider.saveTitleToSharedPreference(c);
                },
                decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(minHeight: 10, minWidth: 10),
                    suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              exProvider.titleContoller.clear();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Color.fromRGBO(102, 51, 204, 1),
                              size: 20.0,
                            ))),
                    isDense: true,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      top: 5.0,
                    ),
                    hintText: '${title[configProvider.activeLanguage()]}',
                    hintStyle: TextStyle(fontSize: 16)),
                controller: exProvider.titleContoller,
              ),
            );
          else if (index == 2) {
            return Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 37.0),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '${exProvider.hrs} : ${exProvider.mins} : ${exProvider.secs}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(102, 51, 204, 1)),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: (exProvider.timerSubscription == null || exProvider.timerSubscription!.isPaused)
                        ? InkWell(
                            onTap: () {
                              if (exProvider.timerSubscription == null) {
                                exProvider.startTimer();
                              } else if (exProvider.timerSubscription!.isPaused) {
                                exProvider.resumeTimer();
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/icons/play.svg',
                              height: 60,
                              width: 60,
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ))
                        : InkWell(
                            onTap: () {
                              exProvider.pauseTimer();
                            },
                            child: SizedBox(
                              child: SvgPicture.asset(
                                'assets/icons/pause.svg',
                                height: 60,
                                width: 60,
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                            )),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, right: 10.0),
                      child: InkWell(
                          onTap: () {
                            if (exProvider.timerSubscription != null || ((exProvider.secs.isNotEmpty && exProvider.secs != '00' || exProvider.hrs.isNotEmpty && exProvider.hrs != '00' || exProvider.mins.isNotEmpty && exProvider.mins != '00'))) exProvider.stopTimer();
                          },
                          child: SizedBox(
                            child: SvgPicture.asset(
                              'assets/icons/stop.svg',
                              color: Color.fromRGBO(196, 196, 196, 1),
                              height: 60,
                              width: 60,
                            ),
                          ))),
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
                  child: Text(
                    '${seeFavWorkouts[configProvider.activeLanguage()]}',
                    style: TextStyle(fontSize: 13.0),
                  ),
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
                child: _buildExerciseListItem('No.', '${exercisesName[configProvider.activeLanguage()]}', 'KG', 'REP', 'RM', Color.fromRGBO(102, 51, 204, 1), 1, exProvider, index, context, configProvider, 'header', extraSpace: true));
          } else if (index == 6) {
            return Container(
                padding: EdgeInsets.only(left: 10, right: 10.0),
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: _buildExerciseListItem('1', '${exProvider.unselectedExercise?.exerciseName == null ? '${exerciseName[configProvider.activeLanguage()]}' : _createWorkOutProvider.getExerciseName(exerciseProvider, configProvider, exProvider.unselectedExercise!.exerciseId ?? 0)}', 'KG', 'REP', exProvider.unselectedExercise?.rm.toString() ?? '1.02', Colors.grey, 3, exProvider, index, context, configProvider, 'footer'));
          } else if (index == 5) {
            index = index - 5;
            return _buildReorderableListView(context);
          } else
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    width: 100,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      color: Color.fromRGBO(170, 170, 170, 1),
                      onPressed: () async {
                        exProvider.removeLifts();
                        await exProvider.saveListToSharePreference();
                      },
                      textColor: Colors.white,
                      child: Text(
                        '${remove[configProvider.activeLanguage()]}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 15.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      color: Color.fromRGBO(102, 51, 204, 1),
                      onPressed: () async {
                        if (exProvider.titleContoller.text.isEmpty) {
                          showSnackBar('${emptyWorkoutTitle[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                          // showToast('${emptyWorkoutTitle[configProvider.activeLanguage()]}');
                        } else {
                          showLoadingDialog(context);
                          exProvider.createWorkOutSession(userPreferences!.getString('sessionKey') ?? '', exProvider.titleContoller.text, DateTime.now().microsecondsSinceEpoch, workOuts, calendarWorkouts, configProvider, context).then((value) {
                            mainScreenProvider.update();
                            Navigator.pop(context);
                          });
                          await exProvider.clearPreferences();
                        }
                      },
                      textColor: Colors.white,
                      child: Text(
                        '${save[configProvider.activeLanguage()]}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
        });
  }

  Widget _buildExerciseListItem(String exerciseNumber, String exerciseName, String kg, String rep, String rm, Color color, int mode, CreateWorkoutProvider mainScreenProvider, int index, BuildContext context, ConfigProvider configProvider, String listMode, {bool extraSpace = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            child: Text(
              exerciseNumber,
              style: TextStyle(color: color, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () async {
              if (mode == 1) {
                //do nothing
              } else if (mode == 2) {
                mainScreenProvider.unselectedExercise = EditableLift.create(mainScreenProvider.selectedLifts[index].exerciseName, mainScreenProvider.selectedLifts[index].exerciseId, mainScreenProvider.selectedLifts[index].bodyPart, 1, 1, 1.02, false, -1);
              } else {
                await _showExercisesDialog(context, configProvider, mainScreenProvider);
              }
            },
            child: Container(
              child: Text(
                exerciseName,
                style: TextStyle(color: color, fontSize: 13),
              ),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 3,
          child: mode == 2
              ? DropdownButton<int>(
                  //  menuMaxHeight: 400,
                  isExpanded: true,
                  underline: SizedBox(),
                  iconSize: 0.0,
                  value: mainScreenProvider.selectedLifts[index].mass,
                  onChanged: (newValue) async {
                    mainScreenProvider.updateActiveExerciseMass(index, newValue!);
                    await mainScreenProvider.saveListToSharePreference();
                  },
                  items: mainScreenProvider.selectedLifts[index].kgs.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: configProvider.measureMode == KG
                          ? Container(alignment: Alignment.center, child: Text('${value}KG', textAlign: TextAlign.left, style: TextStyle(fontSize: 13.0)))
                          : Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${configProvider.getConvertedMass(value.toDouble())}LBS',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                    );
                  }).toList(),
                )
              : mode == 1
                  ? InkWell(
                      onTap: () {
                        configProvider.changeMassMeasurement();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          configProvider.measureMode == KG ? 'KG' : 'LBS',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                        ),
                      ),
                    )
                  : DropdownButton<int>(
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: 0.0,
                      value: mainScreenProvider.unselectedExercise?.mass ?? 1,
                      onChanged: (newValue) async {
                        mainScreenProvider.updateInactiveExerciseMass(newValue!);
                      },
                      items: mainScreenProvider.unselectedExercise?.kgs.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: configProvider.measureMode == KG
                              ? Container(alignment: Alignment.center, child: Text('${value}KG', textAlign: TextAlign.left, style: TextStyle(fontSize: 13.0, color: Colors.grey)))
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${configProvider.getConvertedMass(value.toDouble())}LBS',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 13.0, color: Colors.grey),
                                  ),
                                ),
                        );
                      }).toList(),
                    ),
        ),
        Expanded(
          flex: 2,
          child: mode == 2
              ? Container(
                  child: DropdownButton<int>(
                    // menuMaxHeight: 400,
                    isExpanded: true,
                    underline: SizedBox(),
                    iconSize: 0.0,
                    value: mainScreenProvider.selectedLifts[index].rep,
                    onChanged: (newValue) async {
                      mainScreenProvider.updateRep(index, newValue!);
                      await mainScreenProvider.saveListToSharePreference();
                    },
                    items: mainScreenProvider.selectedLifts[index].reps.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$value',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : mode == 3
                  ? DropdownButton<int>(
                      //  menuMaxHeight: 400,
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: 0.0,

                      value: mainScreenProvider.unselectedExercise?.rep ?? 1,
                      onChanged: (newValue) async {
                        mainScreenProvider.updateInactiveExerciseRep(newValue!);
                      },
                      items: mainScreenProvider.unselectedExercise?.reps.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$value',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13.0, color: Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Text(
                      'REP',
                      style: TextStyle(fontSize: 13.0, color: Color.fromRGBO(102, 51, 204, 1)),
                      textAlign: TextAlign.center,
                    ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              mode != 2 ? rm.toString() : configProvider.getConvertedRM(double.parse(rm)).toString(),
              style: TextStyle(color: color, fontSize: 13.0),
            ),
          ),
        ),
        if (extraSpace)
          Expanded(
            flex: 2,
            child: Container(),
          ),
        if (mode == 2)
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () async {
                mainScreenProvider.updateLift(index);
                mainScreenProvider.saveListToSharePreference();
              },
              icon: mainScreenProvider.selectedLifts[index].isSelected ? Icon(Icons.check_circle, color: Color.fromRGBO(102, 51, 204, 1), size: 30) : SvgPicture.asset('assets/icons/check.svg', height: 15, width: 15),
            ),
          ),
        if (mode > 2)
          IconButton(
            onPressed: () async {
              if (mainScreenProvider.unselectedExercise?.exerciseName != null) {
                mainScreenProvider.addExercise(EditableLift.create(mainScreenProvider.unselectedExercise?.exerciseName, mainScreenProvider.unselectedExercise?.exerciseId, mainScreenProvider.unselectedExercise?.bodyPart, mainScreenProvider.unselectedExercise?.mass ?? 1, mainScreenProvider.unselectedExercise?.rep ?? 1, mainScreenProvider.unselectedExercise?.rm ?? 1.02, true, -1));
                await mainScreenProvider.saveListToSharePreference();
              } else
                showSnackBar('${selectExercise[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
            },
            icon: Icon(Icons.add_circle, color: Color.fromRGBO(170, 170, 170, 1), size: 32),
          ),
      ],
    );
  }
}
