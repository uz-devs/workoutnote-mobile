import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/ui/widgets/CalculationBottomSheet.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'DeltoidOneRepMaxWebViewScreen.dart';

class CalculatorsScreen extends StatefulWidget {
  @override
  _CalculatorsScreenState createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  late double height;

  PersistentBottomSheetController? bottomSheetController;

  var configProvider = ConfigProvider();

  @override
  void dispose() {
    super.dispose();
    if (bottomSheetController != null) {
      bottomSheetController!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    var configProvider = Provider.of<ConfigProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            if (index == 0)
              return _buildDeltoidTestWidget();
            else if (index < 3)
              return _buildCustomButton(metricsNames[index - 1][configProvider.activeLanguage()]!, index);
            else if (index == 3)
              return Container(margin: EdgeInsets.only(left: 15.0, right: 15.0), child: Divider(thickness: 2, color: Color.fromRGBO(102, 51, 204, 0.5)));
            else
              return _buildCustomButton(metricsNames[index - 2][configProvider.activeLanguage()]!, index);
          }),
    );
  }

  Widget _buildCustomButton(String text, int index) {
    return InkWell(
      onTap: () async {
        if (index == 4)
          await showModal(index - 1, '${oneRepMax1[configProvider.activeLanguage()]}', '${oneRepMax4[configProvider.activeLanguage()]}', 'Lift', 'KG', '${oneRepMax5[configProvider.activeLanguage()]}', '${oneRepMax6[configProvider.activeLanguage()]}');
        else if (index == 5)
          await showModal(index - 1, '${plateBarbell1[configProvider.activeLanguage()]}', '${plateBarbell2[configProvider.activeLanguage()]}', 'Total Lift (kg)', 'Bar Weight (kg)', '${plateBarbell3[configProvider.activeLanguage()]}', '${plateBarbell4[configProvider.activeLanguage()]}');
        else if (index == 6) await showModal(index - 1, '${wilks1[configProvider.activeLanguage()]}', '${wilks2[configProvider.activeLanguage()]}', 'Maximum weight', 'Gender', '${wilks3[configProvider.activeLanguage()]}', '${wilks4[configProvider.activeLanguage()]}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
        child: Card(
          elevation: 10,
          color: index == 1 || index == 2 ? Colors.black : Color.fromRGBO(102, 51, 204, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(padding: EdgeInsets.all(15.0), child: Text(text, style: TextStyle(fontSize: 18.0, color: Colors.white))),
        ),
      ),
    );
  }

  Widget _buildDeltoidTestWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          Card(
              //semanticContainer: true,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Image.asset(
                'assets/images/test.png',
                fit: BoxFit.fill,
              )),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: Column(
              children: [
                Text('${deltoid1RMTest[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Container(margin: EdgeInsets.only(top: 10), child: Divider(color: Colors.white, thickness: 1, indent: 10.0, endIndent: 10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          var sessionKey = userPreferences!.getString('sessionKey');
                          var lang = configProvider.activeLanguage() == english ? 'en' : 'kr';
                          var fullUrl = 'https://workoutnote.com/calculators/$sessionKey/deltoid_test/$lang';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OneRepMaxCalWebView('${deltoidTest[configProvider.activeLanguage()]}', fullUrl)));
                        },
                        child: Text('${test[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                    Text('|', style: TextStyle(color: Colors.white)),
                    TextButton(
                        onPressed: () {
                          var sessionKey = userPreferences!.getString('sessionKey');
                          var lang = configProvider.activeLanguage() == english ? 'en' : 'kr';
                          var fullUrl = 'https://workoutnote.com/calculators/$sessionKey/deltoid_result/$lang';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OneRepMaxCalWebView('${deltoidResult[configProvider.activeLanguage()]}', fullUrl)));
                        },
                        child: Text('${result[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> showModal(int mode, String title, String subtitle, String text1, String text2, String text3, String text4) async {
    bottomSheetController = await showModalBottomSheet(isScrollControlled: true, context: context, builder: (context) => CalculationBottomSheet(height, title, subtitle, mode, text1, text2, text3, text4));
  }
}
