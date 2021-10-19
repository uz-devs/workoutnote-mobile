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
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 10.0,
      color: Color.fromRGBO(102, 51, 204, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TargetRegistrationScreen())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Text(
                    '${registerPlan[configProvider.activeLanguage()]}',
                    style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
              Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
