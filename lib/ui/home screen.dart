import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final height;
   HomeScreen(this.height);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var navProvider = MainScreenProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      navProvider = Provider.of<MainScreenProvider>(context, listen: false);
    });
    navProvider.fetchWorkOuts(userPreferences!.getString("sessionKey") ?? "", 1627689600000).then((value) {

      print("yesss");
    });

  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(itemCount: navProvider.workOuts.length,  itemBuilder: (context,  index) {

      if(index == 0)
        return _buildIntroWidget("Ilyosbek");
      else
        return  WorkOutNote(widget.height, navProvider.workOuts[index]);
    });
  }

  Widget _buildIntroWidget(String  name){
    return  Container (
      margin: EdgeInsets.only(left: 20, top: 30),
      child: Text("Hello, ${name}",  style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),),
    );
  }
}
