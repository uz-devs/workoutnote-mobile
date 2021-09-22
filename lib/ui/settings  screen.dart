import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/language%20%20change%20screen.dart';
import 'package:workoutnote/ui/profile%20update%20screen.dart';
import 'package:workoutnote/utils/strings.dart';

import 'login screen.dart';

class SeetingsScreen extends StatefulWidget {
  final height;

  SeetingsScreen(this.height);

  @override
  _SeetingsScreenState createState() => _SeetingsScreenState();
}

class _SeetingsScreenState extends State<SeetingsScreen> {
  var icon = Icon(
    Icons.arrow_forward_ios,
    color: Color.fromRGBO(170, 170, 170, 1),
    size: 20,
  );
  PersistentBottomSheetController? bottomSheetController;

  @override
  void dispose() {
    super.dispose();
    if (bottomSheetController != null) {
      bottomSheetController!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    var homeProvider = Provider.of<MainScreenProvider>(context, listen: false);
    var dialogProvider = Provider.of<ExercisesDialogProvider>(context, listen: false);
    var createWorkOutProvider = Provider.of<CreateWorkoutProvider>(context, listen: false);
    configProvider.setUserInfo();
    return Scaffold(
        body: ListView.separated(
            itemBuilder: (context, index) {
              if (index == 0)
                return Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      '${profileInfo[configProvider.activeLanguage()]}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1), fontSize: 18),
                    ),
                  ),
                );
              else if (index == 1) {
                return InkWell(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdateScreen()));

                  },
                  child: ListTile(
                    dense: true,
                    leading: Text('${profileInfo[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              } else if (index == 2)
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageChangeScreen()));
                  },
                  child: ListTile(
                    dense: true,
                    leading: Text('${languageChange[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              else if (index == 3)
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      '${appInfo[configProvider.activeLanguage()]}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1), fontSize: 18),
                    ),
                  ),
                );
              else if (index == 4)
                return InkWell(
                  child: ListTile(
                    dense: true,
                    leading: Text('${appUsageGuide[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              else if (index == 5)
                return InkWell(
                  child: ListTile(
                    dense: true,
                    leading: Text('${termsAndConditions[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              else if (index == 6)
                return InkWell(
                  child: ListTile(
                    dense: true,
                    leading: Text('${privacyPolicy[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              else if (index == 7)
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      '${customerCenter[configProvider.activeLanguage()]}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1), fontSize: 18),
                    ),
                  ),
                );
              else if (index == 8)
                return InkWell(
                  child: ListTile(
                    dense: true,
                    leading: Text('${customerCenter[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );
              else if (index == 9)
                return InkWell(
                  child: ListTile(
                    dense: true,
                    leading: Text('Q&A'),
                    trailing: icon,
                  ),
                );
              else if (index  == 10)
                return InkWell(
                  onTap: () {
                    configProvider.logout();
                    homeProvider.reset();
                    dialogProvider.reset();
                    createWorkOutProvider.reset();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                  },
                  child: ListTile(
                    dense: true,
                    leading: Text('${logout[configProvider.activeLanguage()]}'),
                    trailing: icon,
                  ),
                );

              else  return Container();

            },
            separatorBuilder: (context, index) {
              if (index == 2 || index == 6 || index == 9) return Divider(height: 1.0, thickness: 4, color: Colors.deepPurpleAccent.withOpacity(0.1));

              return Divider(height: 1.0);
            },
            itemCount: 12));
  }


}
