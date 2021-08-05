
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

      body: ListView.separated(
          itemBuilder: (context,  index) {
            if(index == 0)
              return ListTile(
                leading: Text("English",  style: TextStyle(color: Colors.deepPurpleAccent),),
                trailing: Radio(activeColor: Colors.deepPurpleAccent, groupValue: 1,  onChanged: (value) {  }, value: 1,),);
            else return ListTile(
              leading: Text("한국어",  style: TextStyle(color: Colors.deepPurpleAccent),),
              trailing: Radio(groupValue: 1,  onChanged: (value) {  }, value: 0,),);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: 2)
    );
  }
}
