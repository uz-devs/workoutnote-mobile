import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/CreateWorkoutSessionProvider.dart';
import 'package:workoutnote/business_logic/EditWorkouSessiontProvider.dart';
import 'package:workoutnote/business_logic/ExercisesListProvider.dart';
import 'package:workoutnote/business_logic/HomeProvider.dart';
import 'package:workoutnote/data/models/EditableLiftModel.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/data/models/WorkoutListModel.dart';

import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'ExercisesListDialog.dart';

class EditWorkoutSessionDialog extends StatefulWidget {
  final height;
  final WorkOut workout;

  EditWorkoutSessionDialog(this.height, this.workout);

  @override
  _EditWorkoutSessionDialogState createState() => _EditWorkoutSessionDialogState();
}

class _EditWorkoutSessionDialogState extends State<EditWorkoutSessionDialog> {
  var configProvider = ConfigProvider();
  var workoutSessionListProvider = MainScreenProvider();
  var editWorkouSessionProvider = EditWorkoutProvider();
  var exercisesProvider = ExercisesDialogProvider();
  var createWorkoutProvider = CreateWorkoutProvider();
  bool dataRetrieved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    editWorkouSessionProvider = Provider.of<EditWorkoutProvider>(context, listen: true);
    workoutSessionListProvider = Provider.of<MainScreenProvider>(context, listen: true);
    exercisesProvider = Provider.of<ExercisesDialogProvider>(context, listen: false);
    createWorkoutProvider = Provider.of<CreateWorkoutProvider>(context, listen: false);

    if (!dataRetrieved) {
      dataRetrieved = true;
      editWorkouSessionProvider.getLiftsFromWorkoutSession(widget.workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    int count = 7;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.all(20),
      child: Container(height: 384, child: _buildEditWorkoutList(count)),
    );
  }

  Widget _buildEditWorkoutList(int count) {
    return Scrollbar(
      thickness: 3,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: count,
          itemBuilder: (BuildContext context, index) {
            if (index == 0)
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                        )),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          editWorkouSessionProvider.reset();
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: Color.fromRGBO(102, 51, 204, 1),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else if (index == 1)
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 10.0, top: 10),
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Color.fromRGBO(102, 51, 204, 1),
                  onChanged: (c) async {},
                  decoration: InputDecoration(
                      suffixIconConstraints: BoxConstraints(minHeight: 10, minWidth: 10),
                      isDense: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top: 5.0,
                      ),
                      hintText: '${title[configProvider.activeLanguage()]}',
                      hintStyle: TextStyle(fontSize: 16)),
                  controller: editWorkouSessionProvider.titleController,
                ),
              );
            else if (index == 2)
              return Container(
                margin: EdgeInsets.only(left: 20, bottom: 10.0),
                child: Text(
                  '${calculateDuration(widget.workout.duration ?? 0).item1} : ${calculateDuration(widget.workout.duration ?? 0).item2} : ${calculateDuration(widget.workout.duration ?? 0).item3}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color.fromRGBO(102, 51, 204, 1)),
                ),
              );
            else if (index == 3)
              return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(231, 223, 247, 1),
                      border: Border.all(
                        color: Color.fromRGBO(230, 230, 250, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: _buildExerciseListItem('No.', '${exercisesName[configProvider.activeLanguage()]}', 'KG', 'REP', 'RM', Color.fromRGBO(102, 51, 204, 1), 1, editWorkouSessionProvider, index, context, configProvider));
            else if (index == 4) {
              return _buildReorderableListView();
            } else if (index == 5) {
              return Container(
                  padding: EdgeInsets.only(left: 10, right: 10.0),
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _buildExerciseListItem('1', '${editWorkouSessionProvider.unselectedExercise?.exerciseName == null ? '${exerciseName[configProvider.activeLanguage()]}' : createWorkoutProvider.getExerciseName(exercisesProvider, configProvider, editWorkouSessionProvider.unselectedExercise?.exerciseId ?? 0)}', 'KG', 'REP', 'RM', Colors.grey, 3, editWorkouSessionProvider, index, context, configProvider));
            } else
              return Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      width: 100,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Color.fromRGBO(170, 170, 170, 1),
                        onPressed: () {
                          Navigator.pop(context);
                          editWorkouSessionProvider.reset();
                        },
                        textColor: Colors.white,
                        child: Text('${cancelUpdate[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 20.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Color.fromRGBO(102, 51, 204, 1),
                        onPressed: () {
                          editWorkouSessionProvider.updateAllWorkOutLists(widget.workout, workoutSessionListProvider, configProvider, context);

                          showSnackBar('${workOutUpdateMessage[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);
                          //showToast('${workOutUpdateMessage[configProvider.activeLanguage()]}');
                        },
                        textColor: Colors.white,
                        child: Text('${update[configProvider.activeLanguage()]}'),
                      ),
                    ),
                  ],
                ),
              );
          }),
    );
  }

  Widget _buildReorderableListView() {
    return ReorderableListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      onReorder: editWorkouSessionProvider.reorderList,
      children: List.generate(editWorkouSessionProvider.existingLifts.length, (index) {
        return Container(
            key: Key('${index}'),
            padding: EdgeInsets.only(left: 10, right: 10.0),
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            child: Column(
              children: [
                _buildExerciseListItem((index + 1).toString(), '${createWorkoutProvider.getExerciseName(exercisesProvider, configProvider, editWorkouSessionProvider.existingLifts[index].exerciseId ?? 0)}', '0.0', '0.0', editWorkouSessionProvider.existingLifts[index].rm.toString(), Colors.black, 2, editWorkouSessionProvider, index, context, configProvider),
                Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 1,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ))
              ],
            ));
      }),
    );
  }

  Future<void> _showExercisesDialog(BuildContext context, ConfigProvider configProvider, EditWorkoutProvider editWorkoutProvider, mode, existingLiftIndex) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SearchDialog(widget.height);
        }).then((value) {
      if (mode == 2) {
        Exercise? exercise = value;
        editWorkoutProvider.unselectedExercise = EditableLift.create(exercise?.name, exercise?.id, exercise?.bodyPart, 1, 1, 1.2, false, -1);
      } else {
        editWorkoutProvider.updateLiftExercise(value as Exercise, existingLiftIndex);
      }
    });
  }

  Widget _buildExerciseListItem(String exerciseNumber, String exerciseName, String kg, String rep, String rm, Color color, int mode, EditWorkoutProvider editWorkoutProvider, int index, BuildContext context, ConfigProvider configProvider) {
    print("p1: ${editWorkoutProvider.unselectedExercise?.kgs.length}");
    print("p2: ${editWorkoutProvider.unselectedExercise?.mass}");

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: Text(
              exerciseNumber,
              style: TextStyle(fontSize: 13, color: color),
            ),
          ),
        ),
        Expanded(
          //exercise & lift name
          flex: 5,
          child: Container(
            margin: EdgeInsets.only(left: 21),
            child: GestureDetector(
              onTap: () async {
                if (mode == 1) {
                } else if (mode == 2) {
                  await _showExercisesDialog(context, configProvider, editWorkoutProvider, 1, index);
                } else {
                  await _showExercisesDialog(context, configProvider, editWorkoutProvider, 2, -1);
                }
              },
              child: Text(
                exerciseName,
                style: TextStyle(color: color, fontSize: 13),
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 4,
          child: mode == 2
              ? DropdownButton<int>(
                  isExpanded: true,
                  underline: SizedBox(),
                  iconSize: 0.0,
                  value: editWorkoutProvider.existingLifts[index].mass,
                  onChanged: (newValue) {
                    editWorkoutProvider.updateMass(index, newValue!);
                  },
                  items: editWorkoutProvider.existingLifts[index].kgs.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: configProvider.measureMode == KG
                          ? Text(
                              '${value}KG',
                              style: TextStyle(fontSize: 13),
                            )
                          : Text(
                              '${configProvider.getConvertedMass(value.toDouble())}LBS',
                              style: TextStyle(fontSize: 13),
                            ),
                    );
                  }).toList(),
                )
              : mode == 1
                  ? InkWell(
                      onTap: () {
                        configProvider.changeMassMeasurement();
                      },
                      child: Text(
                        configProvider.measureMode == KG ? 'KG' : 'LBS',
                        style: TextStyle(fontSize: 13, color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    )
                  : DropdownButton<int>(
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: 0.0,
                      value: editWorkoutProvider.unselectedExercise?.mass ?? 1,
                      onChanged: (newValue) {
                        editWorkoutProvider.updateMass(index, newValue!);
                      },
                      items: editWorkoutProvider.unselectedExercise?.kgs.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: configProvider.measureMode == KG
                              ? Text(
                                  '${value}KG',
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                )
                              : Text(
                                  '${configProvider.getConvertedMass(value.toDouble())}LBS',
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                        );
                      }).toList(),
                    ),
        ),
        Expanded(
          flex: 2,
          child: mode == 2
              ? DropdownButton<int>(
                  isExpanded: true,
                  underline: SizedBox(),
                  iconSize: 0.0,
                  value: editWorkoutProvider.existingLifts[index].rep,
                  onChanged: (newValue) {
                    editWorkoutProvider.updateRep(index, newValue!);
                  },
                  items: editWorkoutProvider.existingLifts[index].reps.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Container(
                        child: Text(
                          '$value',
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                )
              : mode == 1
                  ? Text(
                      'REP',
                      style: TextStyle(fontSize: 13, color: mode == 1 ? Color.fromRGBO(102, 51, 204, 1) : Colors.grey),
                    )
                  : DropdownButton<int>(
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: 0.0,
                      value: editWorkoutProvider.unselectedExercise?.rep ?? 1,
                      onChanged: (newValue) {
                        editWorkoutProvider.updateRep(index, newValue!);
                      },
                      items: editWorkoutProvider.unselectedExercise?.reps.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            child: Text(
                              '$value',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
        ),
        Expanded(
          flex: 2,
          child: mode == 1
              ? Container()
              : (mode == 2
                  ? IconButton(
                      onPressed: () async {
                        editWorkouSessionProvider.updateLiftActiveStatus(index);
                      },
                      icon: editWorkouSessionProvider.existingLifts[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Color.fromRGBO(102, 51, 204, 1),
                              size: 30,
                            )
                          : SvgPicture.asset(
                              'assets/icons/check.svg',
                              height: 15,
                              width: 15,
                            ))
                  : IconButton(
                      onPressed: () async {
                        if (editWorkoutProvider.unselectedExercise?.exerciseName != null) {
                          editWorkoutProvider.addExercise(EditableLift.create(editWorkoutProvider.unselectedExercise!.exerciseName, editWorkoutProvider.unselectedExercise!.exerciseId, editWorkoutProvider.unselectedExercise!.bodyPart, 1, 1, 1.2, true, -1));
                        } else
                          showSnackBar('${selectExercise[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                        //showToast('Please, select exercise!');
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Color.fromRGBO(170, 170, 170, 1),
                        size: 32,
                      ),
                    )),
        )
      ],
    );
  }
}
