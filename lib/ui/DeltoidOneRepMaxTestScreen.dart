import 'package:flutter/material.dart';
import 'dart:ui';


class DeltoidOneRepMaxTestScreen extends StatefulWidget {
  const DeltoidOneRepMaxTestScreen({Key? key}) : super(key: key);

  @override
  _DeltoidOneRepMaxTestScreenState createState() => _DeltoidOneRepMaxTestScreenState();
}

class _DeltoidOneRepMaxTestScreenState extends State<DeltoidOneRepMaxTestScreen> {
  List<int> plateNumberList = List.generate(10, (index) => index + 1);
  List<int> dropDownValues = [1, 1, 1, 1, 1, 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: MediaQueryData.fromWindow(window).padding.top),
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(102, 51, 204, 1),
                    ),
                  )),
              Container(
                child: Text(
                  'Deltoid One Rep Max Test',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              _buildCalculationCardWidget(),
              _buildCustomBodyParts('shoulder.png', 'Shoulder(Dumbell Lateral Raise)'),
              _buildCustomBodyParts('shoulder.png', 'Chest(Push up)'),
              _buildCustomBodyParts('shoulder.png', 'Back(Dumbell Raw)'),
              _buildCustomBodyParts('shoulder.png', 'Abs(Crunch)'),
              _buildCustomBodyParts('shoulder.png', 'Legs(Dumbell Squat)'),
              MaterialButton(
                onPressed: (){}, child: Text('Result'),  textColor: Colors.white, color: Color.fromRGBO(102, 51, 204, 1
              ),)
            ],
          ),
        ),
      ),
    );
  }

  _buildCalculationCardWidget() {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      width: double.maxFinite,
      child: Card(
        color: Color.fromRGBO(102, 51, 204, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text(
                'Essential information',
                style: TextStyle(color: Colors.white),
              ),
            ),
            _buildCustomText('Name'),
            _buildCustomTextFormField(TextEditingController(), 'name (e.g: John)', TextInputType.name),
            _buildCustomText('Gender'),
            _buildCustomText('Age'),
            _buildCustomTextFormField(TextEditingController(), 'age (e.g: 30 y.o)', TextInputType.number),
            _buildCustomText('Height'),
            _buildCustomTextFormField(TextEditingController(), 'height (e.g: 175 cm)', TextInputType.number),
            _buildCustomText('Weight'),
            _buildCustomTextFormField(TextEditingController(), 'weight (e,g: 75 kg)', TextInputType.number),
            Container(margin: EdgeInsets.only(bottom: 10.0), child: _buildCustomText('*If you dont write down your physical information directly, recent information will be automatically inserted!'))


          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextFormField(TextEditingController textEditingController, String hintText, TextInputType textInputType) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.white),
        ),
      ),
      margin: EdgeInsets.only(left: 10.0, right: 10),
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontSize: 14),
        keyboardType: textInputType,
        onChanged: (c) async {},
        controller: textEditingController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: 14.0),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCustomText(
    String text,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, top: 10.0),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildCustomBodyParts(String iconName, String title) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20, bottom: 20.0, left: 10.0),
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/images/$iconName',
                    )),
              ),
              Expanded(
                flex: 6,
                child: Container(),
              )
            ],
          )),
    );
  }
}
