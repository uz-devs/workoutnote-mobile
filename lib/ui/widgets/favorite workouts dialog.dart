import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class AllWorkoutsDialog extends StatefulWidget {
  const AllWorkoutsDialog();

  @override
  _AllWorkoutsDialogState createState() => _AllWorkoutsDialogState();
}

class _AllWorkoutsDialogState extends State<AllWorkoutsDialog> {
  MainScreenProvider mainScreenProvider = MainScreenProvider();
  ConfigProvider configProvider = ConfigProvider();
  late double height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: true);
    configProvider = Provider.of<ConfigProvider>(context, listen: true);

    if (!mainScreenProvider.requestDone2) {
      mainScreenProvider.fetchFavoriteWorkoutSessions(userPreferences!.getString('sessionKey') ?? '').then((value) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(

      width: MediaQuery.of(context).size.width,
      child: Dialog(
        //backgroundColor:  Color.fromRGBO(231, 223, 247, 1),

        shape: RoundedRectangleBorder(


            borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(5.0),
          height: 0.9 * height,

          child: Scrollbar(
            radius: Radius.circular(10.0),
            thickness: 5,
            child: _buildWorkoutSessionsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutSessionsList() {
    return ListView.builder(
        itemCount: mainScreenProvider.favoriteWorkOuts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${favoriteWorkoutSesions[configProvider.activeLanguage()]}',
                      style: TextStyle(

                        fontWeight: FontWeight.bold,
                          fontSize: 16, color: Color.fromRGBO(102, 51, 204, 1)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.clear, color: Color.fromRGBO(102, 51, 204, 1)),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  )
                ],
              ),
            );
          } else {
            index = index - 1;
            return WorkOutNote(height, mainScreenProvider.favoriteWorkOuts[index], 3);
          }
        });
  }
}
