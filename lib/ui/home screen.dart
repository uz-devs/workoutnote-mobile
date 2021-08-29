import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';

import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/ui/widgets/workout%20%20create%20card.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final height;
  final width;

  HomeScreen(this.height, this.width);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var navProvider = MainScreenProvider();
  var configProvider = ConfigProvider();
  var exerciseDialogProvider = ExercisesDialogProvider();
  var createWorkoutProvider = CreateWorkoutProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navProvider = Provider.of<MainScreenProvider>(context, listen: true);
    exerciseDialogProvider = Provider.of<ExercisesDialogProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    createWorkoutProvider = Provider.of<CreateWorkoutProvider>(context, listen: true);


    //showLoaderDialog(context);
    if (!navProvider.requestDone1) {
      navProvider.requestDone1 = true;
      navProvider.fetchTodayWorkouts().then((value) {});
      exerciseDialogProvider.fetchExercises().then((value) {
        createWorkoutProvider.restoreAllLifts(exerciseDialogProvider);
      });
      exerciseDialogProvider.fetchBodyParts().then((value) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemsList();
  }

  Widget _buildItemsList() {
    return ListView.builder(
        itemCount: navProvider.workOuts.length + 3,
        itemBuilder: (context, index) {
          if (index == 0)
            return Container(
              margin: EdgeInsets.only(left: 20, top: 30, bottom: 20),
              child: Text(
                "${welcomeMessage[configProvider.activeLanguage()]}, ${userPreferences!.getString("name") ?? ""}",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            );
          else if (index == 1) {
            return CreateWorkOutCard(widget.width, widget.height, navProvider.workOuts, navProvider.calendarWorkouts);
          } else if (index == 2) {
            return Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now()).substring(0,3).toUpperCase()}",
                  style: TextStyle(fontSize: 24, color: Color.fromRGBO(102, 51, 204, 1)),
                ));
          } else {
            index = index - 3;
            return WorkOutNote(widget.height, navProvider.workOuts[index], 1);
          }
        });
  }
}
