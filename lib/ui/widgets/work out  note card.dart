import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/edit%20workout%20%20provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/widgets/edit%20workout%20session%20%20dialog.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import '../nav controller.dart';

class WorkOutNote extends StatefulWidget {
  final height;
  final workout;
  final mode;

  WorkOutNote(this.height, this.workout, this.mode);

  @override
  _WorkOutNoteState createState() => _WorkOutNoteState();
}

class _WorkOutNoteState extends State<WorkOutNote> {
  ConfigProvider configProvider = ConfigProvider();
  MainScreenProvider mainScreenProvider = MainScreenProvider();
  CreateWorkoutProvider createWorkoutProvider = CreateWorkoutProvider();
  ExercisesDialogProvider dialogProvider = ExercisesDialogProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: true);
    createWorkoutProvider =
        Provider.of<CreateWorkoutProvider>(context, listen: false);
    dialogProvider =
        Provider.of<ExercisesDialogProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.workout.lifts!.length + 3;
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.5,
                color: widget.mode == 3
                    ? Color.fromRGBO(102, 51, 204, 1)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: _buildListViewWidget(count)),
    );
  }

  Widget _buildListViewWidget(int count) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 10.0),
                        child: Text(
                          widget.workout.title.length > 15
                              ? "${widget.workout.title.substring(0, 14)}..."
                              : "${widget.workout.title}",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color.fromRGBO(102, 51, 204, 1)),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 9.0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {

                                if (!widget.workout.isFavorite)
                                  mainScreenProvider
                                      .setFavoriteWorkOut(
                                          userPreferences!
                                                  .getString("sessionKey") ??
                                              "",
                                          widget.workout.id ?? -1,
                                          widget.mode)
                                      .then((value) {
                                    setState(() {});
                                  });
                                else
                                  mainScreenProvider
                                      .unsetFavoriteWorkOut(
                                          userPreferences!
                                                  .getString("sessionKey") ??
                                              "",
                                          widget.workout.id ?? -1,
                                          widget.mode)
                                      .then((value) {
                                    setState(() {});
                                  });

                            },
                            icon: widget.workout.isFavorite
                                ? SvgPicture.asset(
                                    "assets/icons/liked.svg",
                                    height: 17,
                                    width: 17,
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/unliked.svg",
                                    height: 17,
                                    width: 17,
                                  ))),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 15.0, top: 10.0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () async {
                          await _showOptionDialog(
                              configProvider, mainScreenProvider);
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/menu.svg",
                          height: 17.0,
                          width: 17.0,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                  child: Divider(
                    color: Colors.black54,
                  ),
                )
              ],
            );
          } else if (index == count - 2) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(
                "${calculateDuration(widget.workout.duration ?? 0).item1} : ${calculateDuration(widget.workout.duration ?? 0).item2} : ${calculateDuration(widget.workout.duration ?? 0).item3}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromRGBO(102, 51, 204, 1)),
              ),
            );
          } else if (index == count - 1) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(102, 51, 204, 1),
                textColor: Colors.white,
                child: Text("${repeat[configProvider.activeLanguage()]}"),
                onPressed: () {
                  mainScreenProvider
                      .repeatWorkoutSession(
                          widget.workout.id ?? -1,
                          createWorkoutProvider,
                          dialogProvider.allExercises,
                          widget.mode)
                      .then((value) {
                    if (widget.mode == 3) {

                      Navigator.pop(context);
                    } else if (widget.mode == 2) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NavController(),
                        ),
                            (route) => false,
                      );
                    }
                  });
                },
              ),
            );
          } else {
            index = index - 1;

            String mass =
                "${configProvider.getConvertedMass(widget.workout.lifts![index].liftMas ?? 0)}";
            String rm =
                "${configProvider.getConvertedRM(widget.workout.lifts![index].oneRepMax ?? 0)}";
            String identifier = configProvider.measureMode == KG ? "KG" : "LBS";
            return Container(
                margin: EdgeInsets.only(left: 20.0),
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                    "${index + 1}. ${widget.workout.lifts![index].exerciseName}, ${mass} ${identifier}, ${widget.workout.lifts![index].repetitions} REP, ${rm} RM"));
          }
        });
  }

  //region  dialogs
  Future<void> _showOptionDialog(
      ConfigProvider configProvider, MainScreenProvider mainScreenProvider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: () async {
                        await _showEditWorkoutDialog(context, widget.workout);
                        Navigator.pop(context);
                      },
                      child: Text("${edit[configProvider.activeLanguage()]}",
                          style: TextStyle(fontSize: 16.0)),
                    )),
                Divider(),
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                        onPressed: () async {
                          await _showDeleteConfirmDialog();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "${delete[configProvider.activeLanguage()]}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ))),
              ],
            ),
          );
        });
  }

  Future<void> _showEditWorkoutDialog(
      BuildContext context, WorkOut workOut) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditWorkoutSessionDialog(widget.height, workOut);
        }).then((value) {
      Provider.of<EditWorkoutProvider>(context, listen: false).reset();
    });
  }

  Future<void> _showDeleteConfirmDialog() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: 186.2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 8,
                      child: Container(
                        margin: EdgeInsets.only(left: 50.0, right: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "${deleteMessage[configProvider.activeLanguage()]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Divider(),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "${deleteCancel[configProvider.activeLanguage()]}",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () {
                                mainScreenProvider
                                    .deleteWorkoutSession(
                                        userPreferences!
                                                .getString("sessionKey") ??
                                            "",
                                        widget.workout.id ?? -1)
                                    .then((value) {
                                  if (value) {
                                    showToast(
                                        "${deleteSuccess[configProvider.activeLanguage()]}");
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text(
                                  "${deleteYes[configProvider.activeLanguage()]}",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18)),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
//endregion

}
