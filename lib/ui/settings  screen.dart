import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/business%20logic/user%20management%20%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/ui/language%20%20change%20screen.dart';
import 'package:workoutnote/ui/profile%20update%20screen.dart';
import 'package:workoutnote/utils/strings.dart';

class SeetingsScreen extends StatefulWidget {
  final height;

  SeetingsScreen(this.height);

  @override
  _SeetingsScreenState createState() => _SeetingsScreenState();
}

class _SeetingsScreenState extends State<SeetingsScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserManagement>(context, listen: false);
    var configProvider = Provider.of<ConfigProvider>(context, listen: true );

    return ListView.separated(

        itemBuilder: (context, index) {
          if (index == 0)
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.account_circle),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "${profileInfo[configProvider.activeLanguage()]}",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent, fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          else if (index == 1) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdateScreen()));
              },
              child: ListTile(
                dense: true,
                leading: Text("${profileInfo[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          } else if (index == 2)
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageChangeScreen()));
              },
              child: ListTile(
                dense: true,
                leading: Text("${languageChange[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 3)
            return Container(

              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "${appInfo[configProvider.activeLanguage()]}",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent,  fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          else if (index == 4)
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text("${appUsageGuide[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 5)
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text("${termsAndConditions[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 6)
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text("${privacyPolicy[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 7)
            return Container(

              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.support_agent),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "${customerCenter[configProvider.activeLanguage()]}",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent,  fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          else if (index == 8)
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text( "${customerCenter[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 9)
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text("Q&A"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 10)
            return InkWell(
              onTap: (){
                userProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (Route<dynamic> route) => false);

              },
              child: ListTile(
                dense: true,
                leading: Text("${logout[configProvider.activeLanguage()]}"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else {
            return InkWell(
              child: ListTile(
                dense: true,
                leading: Text("${deleteAccount[configProvider.activeLanguage()]}"),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          if (index == 2 || index == 6 || index == 9) return Divider(thickness: 4, color: Colors.deepPurpleAccent.withOpacity(0.1));

          return Divider();
        },
        itemCount: 12);
  }
}
