import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/edit%20workout%20%20provider.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'exercises  search dialog.dart';

class EditWorkoutSessionDialog extends StatefulWidget {
  final height;
  final WorkOut workout;

  EditWorkoutSessionDialog(this.height, this.workout);

  @override
  _EditWorkoutSessionDialogState createState() =>
      _EditWorkoutSessionDialogState();
}

class _EditWorkoutSessionDialogState extends State<EditWorkoutSessionDialog> {
  var configProvider = ConfigProvider();
  var workoutSessionListProvider = MainScreenProvider();
  var editWorkouSessionProvider = EditWorkoutProvider();
  bool dataRetrieved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    editWorkouSessionProvider =
        Provider.of<EditWorkoutProvider>(context, listen: true);
    workoutSessionListProvider =
        Provider.of<MainScreenProvider>(context, listen: true);

    if (!dataRetrieved) {
      dataRetrieved = true;
      editWorkouSessionProvider.getLiftsFromWorkoutSession(widget.workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    int count = editWorkouSessionProvider.existingLifts.length + 6;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.all(20),
      child: Container(height: 384, child: _buildEditWorkoutList(count)),
    );
  }

  Widget _buildEditWorkoutList(int count) {
    return Scrollbar(
      thickness: 3,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (BuildContext context, int index) {
            if (index > 3)
              return Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Divider(
                    height: 1,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ));
            else
              return Divider(
                height: 0.0,
                color: Colors.white,
              );
          },
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
                          "${DateFormat("yyyy.MM.dd",  configProvider.activeLanguage() == english?"en_EN":"ko_KR",).format(DateTime.now())}. ${DateFormat("EEEE", configProvider.activeLanguage() == english?"en_EN":"ko_KR",).format(DateTime.now()).substring(0, 3).toUpperCase()}",
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
                    bottom: BorderSide(
                        width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                  ),
                ),
                margin: EdgeInsets.only(
                    bottom: 10.0, left: 20.0, right: 10.0, top: 10),
                child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Color.fromRGBO(102, 51, 204, 1),
                  onChanged: (c) async {},
                  decoration: InputDecoration(
                      suffixIconConstraints:
                          BoxConstraints(minHeight: 10, minWidth: 10),
                      // suffixIcon: Padding(
                      //     padding: EdgeInsets.only(top: 8.0),
                      //     child: IconButton(
                      //         padding: EdgeInsets.zero,
                      //         constraints: BoxConstraints(),
                      //         onPressed: () {
                      //           editWorkouSessionProvider.titleController
                      //               .clear();
                      //           FocusScope.of(context).unfocus();
                      //         },
                      //         icon: Icon(
                      //           Icons.clear,
                      //           color: Color.fromRGBO(102, 51, 204, 1),
                      //           size: 20.0,
                      //         ))),
                      isDense: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top: 5.0,
                      ),
                      hintText: "${title[configProvider.activeLanguage()]}",
                      hintStyle: TextStyle(fontSize: 16)),
                  controller: editWorkouSessionProvider.titleController,
                ),
              );
            else if (index == 2)
              return Container(
                margin: EdgeInsets.only(left: 20, bottom: 10.0),
                child: Text(
                  "${calculateDuration(widget.workout.duration ?? 0).item1} : ${calculateDuration(widget.workout.duration ?? 0).item2} : ${calculateDuration(widget.workout.duration ?? 0).item3}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromRGBO(102, 51, 204, 1)),
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
                  child: _buildExerciseListItem(
                      "No.",
                      "${exercisesName[configProvider.activeLanguage()]}",
                      "KG",
                      "REP",
                      "RM",
                      Color.fromRGBO(102, 51, 204, 1),
                      1,
                      editWorkouSessionProvider,
                      index,
                      context,
                      configProvider));
            else if (index >= 4 && index < count - 2) {
              index = index - 4;
              return InkWell(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10.0),
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: _buildExerciseListItem(
                        (index + 1).toString(),
                        "${editWorkouSessionProvider.existingLifts[index].exerciseName}",
                        "0.0",
                        "0.0",
                        editWorkouSessionProvider.existingLifts[index].rm
                            .toString(),
                        Colors.black,
                        2,
                        editWorkouSessionProvider,
                        index,
                        context,
                        configProvider)),
              );
            } else if (index == count - 2) {
              return Container(
                  padding: EdgeInsets.only(left: 10, right: 10.0),
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _buildExerciseListItem(
                      "1",
                      "${editWorkouSessionProvider.unselectedExercise == null ? "${exerciseName[configProvider.activeLanguage()]}" : editWorkouSessionProvider.unselectedExercise!.name}(${(editWorkouSessionProvider.unselectedExercise == null ? "${bodyPart[configProvider.activeLanguage()]}" : editWorkouSessionProvider.unselectedExercise!.bodyPart)})",
                      "KG",
                      "REP",
                      "RM",
                      Colors.grey,
                      3,
                      editWorkouSessionProvider,
                      index,
                      context,
                      configProvider));
            } else
              return Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom:  10.0),
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
                        child: Text(
                            "${cancelUpdate[configProvider.activeLanguage()]}",
                            style: TextStyle(fontSize: 16.0)),
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
                          editWorkouSessionProvider.updateAllWorkOutLists(
                              widget.workout,
                              workoutSessionListProvider,
                              configProvider,
                              context);

                          showToast(
                              "${workOutUpdateMessage[configProvider.activeLanguage()]}");
                        },
                        textColor: Colors.white,
                        child:
                            Text("${update[configProvider.activeLanguage()]}"),
                      ),
                    ),
                  ],
                ),
              );
          }),
    );
  }

  Future<void> _showExercisesDialog(
      BuildContext context,
      ConfigProvider configProvider,
      EditWorkoutProvider editWorkoutProvider,
      mode,
      existingLiftIndex) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SearchDialog(widget.height);
        }).then((value) {
      if (mode == 2)
        editWorkoutProvider.unselectedExercise = value as Exercise;
      else {

        editWorkoutProvider.updateLiftExercise(
            value as Exercise, existingLiftIndex);
      }
    });
  }

  Widget _buildExerciseListItem(
      String exerciseNumber,
      String exerciseName,
      String kg,
      String rep,
      String rm,
      Color color,
      int mode,
      EditWorkoutProvider editWorkoutProvider,
      int index,
      BuildContext context,
      ConfigProvider configProvider) {
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
            child: InkWell(
              onTap: () async {
                if (mode == 1) {
                } else if (mode == 2) {
                  await _showExercisesDialog(
                      context, configProvider, editWorkoutProvider, 1, index);
                } else {
                  await _showExercisesDialog(
                      context, configProvider, editWorkoutProvider, 2, -1);
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
                  items: editWorkoutProvider.existingLifts[index].kgs
                      .map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: configProvider.measureMode == KG
                          ? Text(
                              "${value}KG",
                              style: TextStyle(fontSize: 13),
                            )
                          : Text(
                              "${configProvider.getConvertedMass(value.toDouble())}LBS",
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
                        configProvider.measureMode == KG ? "KG" : "LBS",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    )
                  : Text(
                      configProvider.measureMode == KG ? "KG" : "LBS",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
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
                  items: editWorkoutProvider.existingLifts[index].reps
                      .map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Container(
                        child: Text(
                          "$value",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  "REP",
                  style: TextStyle(
                      fontSize: 13,
                      color: mode == 1
                          ? Color.fromRGBO(102, 51, 204, 1)
                          : Colors.grey),
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
                      icon: editWorkouSessionProvider
                              .existingLifts[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Color.fromRGBO(102, 51, 204, 1),
                              size: 30,
                            )
                          : SvgPicture.asset(
                              "assets/icons/check.svg",
                              height: 15,
                              width: 15,
                            ))
                  : IconButton(
                      onPressed: () async {
                        if (editWorkoutProvider.unselectedExercise != null) {
                          editWorkoutProvider.addExercise(EditableLift.create(
                              editWorkoutProvider.unselectedExercise!.name,
                              editWorkoutProvider.unselectedExercise!.id,
                              editWorkoutProvider.unselectedExercise!.bodyPart,
                              1,
                              1,
                              1.0,
                              true,
                              -1));
                        } else
                          showToast("Please, select exercise!");
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
