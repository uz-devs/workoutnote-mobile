
import 'package:flutter/material.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen() ;

  @override
  _LanguageChangeScreenState createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(

          icon: Icon(Icons.arrow_back_ios),
          color: Colors.deepPurpleAccent,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("Language settings",  style: TextStyle(color: Colors.deepPurpleAccent),),
      ),
    );
  }
}
