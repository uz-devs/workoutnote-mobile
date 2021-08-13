import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/home%20%20%20screen%20provider.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navProvider = Provider.of<MainScreenProvider>(context, listen: true);
    if(!navProvider.requestDone1){
      navProvider.requestDone1 = true;
      navProvider.fetchWorkOuts(userPreferences!.getString("sessionKey") ?? "", DateTime.now().millisecondsSinceEpoch).then((value) {
      });
    }
  }
  @override
  Widget build(BuildContext context) {


    var configProvider = Provider.of<ConfigProvider>(context, listen: true);


    if(userPreferences!.getString("sessionKey") == null){
        navProvider.reset();
    }

    return  ListView.builder(
        itemCount: navProvider.workOuts.length+3,  itemBuilder: (context,  index) {
          if(index == 0)
        return Container (
          margin: EdgeInsets.only(left: 20, top: 30, bottom: 20),
          child: Text("${welcomeMessage[configProvider.activeLanguage()]}, ${userPreferences!.getString("name")}",  style: TextStyle(
            fontSize: 30,
          ),),
        );
      else if (index == 1){
        return CreateWorkOutCard(widget.width,  widget.height, navProvider.workOuts, rerunHome);
      }

      else if (index == 2 ){
        return Container(
          margin: EdgeInsets.only(left: 20.0),
            child: Text(
              "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",
              style: TextStyle(fontSize: 25, color: Color.fromRGBO(102, 51, 204, 1)),
            ));
      }
      else {
        index = index - 3;
        return WorkOutNote(widget.height, navProvider.workOuts[index], 1);
      }
      });
  }


  void rerunHome(){
    setState(() {

    });
  }


}
