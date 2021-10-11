
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/ui/TargetRegisterScreen.dart';
import 'package:workoutnote/utils/Strings.dart';


class TargetRegisterWidget extends StatelessWidget {
  const TargetRegisterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(10.0),

      child: Card(
        elevation: 10.0,
        color: Color.fromRGBO(102, 51, 204, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 5.0,  bottom: 5.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text('${registerPlan[configProvider.activeLanguage()]}',  style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)),
              IconButton(icon: Icon(Icons.add_circle_outline, color: Colors.white,),  onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TargetRegistrationScreen()),
                );

              },)
            ],
          ),
        ),
      ),
    );
  }
}
