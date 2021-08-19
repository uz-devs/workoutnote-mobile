import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/edit%20workout%20%20provider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'exercises  search dialog.dart';

class EditWorkoutSessionDialog extends StatefulWidget {
  final height;
  final  WorkOut workout;

  EditWorkoutSessionDialog(this.height, this.workout);

  @override
  _EditWorkoutSessionDialogState createState() => _EditWorkoutSessionDialogState();
}

class _EditWorkoutSessionDialogState extends State<EditWorkoutSessionDialog> {
  var configProvider = ConfigProvider();
  var exProvider = EditWorkoutProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    exProvider = Provider.of<EditWorkoutProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.workout.lifts!.length + 3;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.all(20),
      child: Container(height: 0.6 * widget.height, child: _buildEditWorkoutList()),
    );
  }

  Widget _buildEditWorkoutList(int count ) {
    return Scrollbar(
      thickness: 3,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index){
             return  Divider();
          },
          itemCount: count,
          itemBuilder: (BuildContext context, index) {
            if (index == 0) return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        )),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Color.fromRGBO(102, 51, 204, 1),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else if (index == 1) return Container(
                margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10),
                child: TextFormField(
                  onChanged: (c) async {
                    // await exProvider.saveTitleToSharedPreference(c);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5.0),
                    hintText: "${title[configProvider.activeLanguage()]}",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                    ),
                  ),
                //  controller: exProvider.titleContoller,
                ),
              );
            else  if (index == 2) return Container(child: Text("TIME"),);
            else if(index  == 3)    return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(231, 223, 247, 1),
                    border: Border.all(
                      color: Color.fromRGBO(230, 230, 250, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: _buildExerciseListItem("No.", "${exercisesName[configProvider.activeLanguage()]}", "KG", "REP", "RM", Color.fromRGBO(102, 51, 204, 1), 1, exProvider, index, context, configProvider));
            else  if(index >=4 &&  index  < count - 2 ) {
              index = index - 4;

              return Container(
                  padding: EdgeInsets.only(left: 10, right: 10.0),
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _buildExerciseListItem((index + 1).toString(), "${widget.workout.lifts![index].exerciseName}(${widget. workout.lifts![index].bodyPart})", "0.0", "0.0", exProvider.selectedLifts[index].rm.toString(), Colors.black, 2, exProvider, index, context, configProvider));
            }
            else return Container(
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
                        onPressed: () async {},
                        textColor: Colors.white,
                        child: Text("${cancelUpdate[configProvider.activeLanguage()]}"),
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
                        onPressed: () async {},
                        textColor: Colors.white,
                        child: Text("${update[configProvider.activeLanguage()]}"),
                      ),
                    ),
                  ],
                ),
              );

          }),
    );
  }

  Future<void> _showExercisesDialog(BuildContext context, ConfigProvider configProvider, CreateWorkoutProvider exProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SearchDialog(widget.height);
        }).then((value) {
      exProvider.unselectedExercise = value as Exercise;
    });
  }

  Widget _buildExerciseListItem(String exerciseNumber, String exerciseName, String kg, String rep, String rm, Color color, int mode, EditWorkoutProvider mainScreenProvider, int index, BuildContext context, ConfigProvider configProvider) {
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
                mainScreenProvider.unselectedExercise = Exercise(mainScreenProvider.selectedLifts[index].exerciseId, mainScreenProvider.selectedLifts[index].exerciseName, mainScreenProvider.selectedLifts[index].bodyPart, "", false, NameTranslation(""));
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
              configProvider.changeMassMeasurement();
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
              mode != 2 ? rm.toString() : configProvider.getConvertedRM(double.parse(rm)).toString(),
              style: TextStyle(color: color),
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
                mainScreenProvider.updateLift(index);
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
                mainScreenProvider.addExercise(EditableLift.create(mainScreenProvider.unselectedExercise!.name, mainScreenProvider.unselectedExercise!.id, mainScreenProvider.unselectedExercise!.bodyPart, 1, 1, 1.0, true, -1));
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
