
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/ui/widgets/workout%20%20create%20card.dart';
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
      navProvider.fetchWorkOuts(userPreferences!.getString("sessionKey") ?? "", 1627689600000).then((value) {
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: navProvider.workOuts.length+2,  itemBuilder: (context,  index) {

      if(index == 0)
        return _buildIntroWidget("${userPreferences!.getString("name")}");
      else if (index == 1){
        return CreateWorkOutCard(widget.width,  widget.height);
      }
      else {
        index = index - 2;
        return WorkOutNote(widget.height, navProvider.workOuts[index]);
      }
      });
  }

  Widget _buildIntroWidget(String  name){
    return  Container (
      margin: EdgeInsets.only(left: 20, top: 30),
      child: Text("Hello, ${name}",  style: TextStyle(
        fontSize: 20,
      ),),
    );
  }
}
