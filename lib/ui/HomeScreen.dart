import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/CreateWorkoutSessionProvider.dart';
import 'package:workoutnote/business_logic/ExercisesListProvider.dart';
import 'package:workoutnote/business_logic/HomeProvider.dart';
import 'package:workoutnote/ui/widgets/CreateWorkoutCard.dart';
import 'package:workoutnote/ui/widgets/WorkoutnoteCard.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class HomeScreen extends StatefulWidget {
  final height;
  final width;

  HomeScreen(this.height, this.width);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mainProvider = MainScreenProvider();
  var configProvider = ConfigProvider();
  var exerciseDialogProvider = ExercisesDialogProvider();
  var createWorkoutProvider = CreateWorkoutProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    mainProvider = Provider.of<MainScreenProvider>(context, listen: true);
    exerciseDialogProvider = Provider.of<ExercisesDialogProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    createWorkoutProvider = Provider.of<CreateWorkoutProvider>(context, listen: true);

    //showLoaderDialog(context);
    if (!mainProvider.todayWorkoutsFetched) {
      mainProvider.fetchTodayWorkouts().then((value) {
        if (!mainProvider.isCalendarWorkoutsRequestDone && mainProvider.calendarResponseCode != SUCCESS) {
          mainProvider.fetchCalendarWorkoutSessions().then((value) async {});
        }
      });
      if (exerciseDialogProvider.allExercises.isEmpty) {
        exerciseDialogProvider.fetchExercises().then((value) {
          createWorkoutProvider.restoreAllLifts(exerciseDialogProvider);
        });
        exerciseDialogProvider.fetchBodyParts().then((value) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemsList();
  }

  Widget _buildItemsList() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          FocusScope.of(context).unfocus();
        }
        return false;
      },
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: mainProvider.workOuts.length + 3,
          itemBuilder: (context, index) {
            if (index == 0)
              return Container(margin: EdgeInsets.only(left: 20, top: 30, bottom: 20), child: RichText(text: TextSpan(children: [TextSpan(text: '${welcomeMessage[configProvider.activeLanguage()]}, ', style: TextStyle(fontSize: 30, color: Colors.black)), TextSpan(text: '${userPreferences!.getString('name') ?? ''}', style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontSize: 30))])));
            else if (index == 1) {
              return WorkoutCreatorWidget(widget.width, widget.height, mainProvider.workOuts, mainProvider.calendarWorkouts);
            } else if (index == 2) {
              if (mainProvider.workOuts.isEmpty)
                return Center(child: Container(margin: EdgeInsets.all(10.0), child: Text('${emptyWorkouts[configProvider.activeLanguage()]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(102, 51, 204, 1)))));
              else
                return Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      '${DateFormat(
                        'yyyy.MM.dd',
                        configProvider.activeLanguage() == english ? 'en_EN' : 'ko_KR',
                      ).format(
                        DateTime.now(),
                      )}, ${DateFormat(
                        'EEEE',
                        configProvider.activeLanguage() == english ? 'en_EN' : 'ko_KR',
                      ).format(DateTime.now()).substring(0, configProvider.activeLanguage() == english ? 3 : 1).toUpperCase()}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color.fromRGBO(102, 51, 204, 1)),
                    ));
            } else {
              index = index - 3;
              return WorkOutNote(widget.height, mainProvider.workOuts[index], 1);
            }
          }),
    );
  }
}
