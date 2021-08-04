import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/user%20management%20%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/ui/language%20%20change%20screen.dart';
import 'package:workoutnote/ui/profile%20update%20screen.dart';

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
                      "Profile info",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent),
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
                leading: Text("Profile info"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          } else if (index == 2)
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageChangeScreen()));
              },
              child: ListTile(
                leading: Text("Language settings"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 3)
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "App info",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent),
                    ),
                  ),
                ],
              ),
            );
          else if (index == 4)
            return InkWell(
              child: ListTile(
                leading: Text("App usage guide"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 5)
            return InkWell(
              child: ListTile(
                leading: Text("Terms and Conditions"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 6)
            return InkWell(
              child: ListTile(
                leading: Text("Privacy Policy"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 7)
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.support_agent),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Customer center",
                      style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.deepPurpleAccent),
                    ),
                  ),
                ],
              ),
            );
          else if (index == 8)
            return InkWell(
              child: ListTile(
                leading: Text("Customer center"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else if (index == 9)
            return InkWell(
              child: ListTile(
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
                leading: Text("Logout"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            );
          else {
            return InkWell(
              child: ListTile(
                leading: Text("Delete account"),
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
