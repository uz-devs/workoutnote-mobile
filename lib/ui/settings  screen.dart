import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/user%20management%20%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';

class SeetingsScreen extends StatefulWidget {
   final height;
   SeetingsScreen(this.height);

  @override
  _SeetingsScreenState createState() => _SeetingsScreenState();
}

class _SeetingsScreenState extends State<SeetingsScreen> {
  @override
  Widget build(BuildContext context) {

    var userProvider = Provider.of<UserManagement>(context,  listen: false);
    return Center(
      child: MaterialButton(
        color: Colors.grey,
        textColor: Colors.white,
        onPressed: (){
           userProvider.logout().then((value){
             if(value){
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (Route<dynamic> route) => false);
             }
           });
        },
        child: Text("Logout"),
      ),


    );
  }
}
