import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'NavigationController.dart';

class MyIntroductionScreen extends StatefulWidget {
  const MyIntroductionScreen();

  @override
  _MyIntroductionScreenState createState() => _MyIntroductionScreenState();
}

class _MyIntroductionScreenState extends State<MyIntroductionScreen> {

  PageController controller =  PageController();

  @override
  void initState() {
    super.initState();
    appPreferences!.setBool('intro_started', true).then((value) {
      print('heyyy are you okay?');
    });

  }

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
          child: PageView(
            controller: controller,
            
        children: [
          Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    child: Image.asset(
                  'assets/images/intro_screen1.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(bottom: 30.0, left: 15.0, right: 15.0),
                      child: MaterialButton(

                          height: 50,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(102, 51, 204, 1)
                              ),
                              borderRadius: BorderRadius.circular(25.0)
                          ),

                          child: Text(
                            '${introBackButton[configProvider.activeLanguage()]}',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.white,
                              )),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Color.fromRGBO(32, 10, 58, 1),
                                radius: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    child: Image.asset(
                  'assets/images/intro_screen2.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(bottom: 30.0, left: 15.0, right: 15.0),
                      child: MaterialButton(

                        height: 50,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromRGBO(102, 51, 204, 1)
                          ),
                          borderRadius: BorderRadius.circular(25.0)
                        ),

                          child: Text(
                            '${introStartButton[configProvider.activeLanguage()]}',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavController()), (Route<dynamic> route) => false);
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Color.fromRGBO(32, 10, 58, 1),
                                radius: 6,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.white,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }


}
