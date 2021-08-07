
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen() ;

  @override
  _LanguageChangeScreenState createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  int value = 1;
  String item = english;
  List<Language> lList = [Language(english, 1), Language(korean, 2)];

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true );
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
        title: Text("${languagesettingsscreenTitle[configProvider.activeLanguage()]}",  style: TextStyle(color: Colors.deepPurpleAccent),),
      ),

      body: Consumer<ConfigProvider>(builder: (context, config, widget) {
        return ListView(
          children: lList.map((e)
          => RadioListTile<int?>(
              title: Text("${e.name}"),
              value:e.index, groupValue: config.value(), onChanged: (val) {
                config.changeLanguage(val!, lList).then((value) {
                  setState(() {
                  });
                });

              })).toList(),
        );
      }));



  }
}


