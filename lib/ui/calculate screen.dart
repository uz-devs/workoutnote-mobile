import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/ui/widgets/calculation%20bottom%20%20sheet.dart';
import 'package:workoutnote/utils/strings.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen();

  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  late double height;
  PersistentBottomSheetController? bottomSheetController;

  var configProvider = ConfigProvider();
  List<String> koreanNames = [oneRepMax1[korean] ?? "", plateBarbell1[korean] ?? "", powerLiftingTitle[korean] ?? "", wilksTitle[korean] ?? ""];
  List<String> englishNames = [oneRepMax1[english] ?? "", plateBarbell1[english] ?? "", powerLiftingTitle[english] ?? "", wilksTitle[english] ?? ""];

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
          itemCount: 4,
          itemBuilder: (context, index) {
            if (configProvider.activeLanguage() == english)
              return _buildCustomButton(englishNames[index], index);
            else
              return _buildCustomButton(koreanNames[index], index);
          }),
    );
  }

  Widget _buildCustomButton(String text, int index) {
    return InkWell(
      onTap: () async {
        if (index == 0)
          await showModal(index + 1, "${oneRepMax1[configProvider.activeLanguage()]}", "${oneRepMax4[configProvider.activeLanguage()]}", "Lift", "KG", "${oneRepMax5[configProvider.activeLanguage()]}", "${oneRepMax6[configProvider.activeLanguage()]}");
        else if (index == 1)
          await showModal(index + 1, "${plateBarbell1[configProvider.activeLanguage()]}", "${plateBarbell2[configProvider.activeLanguage()]}", "Total Lift (kg)", "Bar Weight (kg)", "${plateBarbell3[configProvider.activeLanguage()]}", "${plateBarbell4[configProvider.activeLanguage()]}");
        else if (index == 3) await showModal(index + 1, "${wilks1[configProvider.activeLanguage()]}", "${wilks2[configProvider.activeLanguage()]}", "Maximum weight", "Gender", "${wilks3[configProvider.activeLanguage()]}", "${wilks4[configProvider.activeLanguage()]}");
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
        child: Card(
          elevation: 10,
          color: Color.fromRGBO(102, 51, 204, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              )),
        ),
      ),
    );
  }

  Future<void> showModal(int mode, String title, String subtitle, String text1, String text2, String text3, String text4) async {
    bottomSheetController = await showBottomSheet(context: context,
        builder: (context) =>
            CalculationBottomSheet(
                height,
                title,
                subtitle,
                mode,
                text1,
                text2,
                text3,
                text4));
  }

}
