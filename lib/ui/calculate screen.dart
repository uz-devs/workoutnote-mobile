import 'package:flutter/material.dart';
import 'package:workoutnote/ui/widgets/calculation%20bottom%20%20sheet.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen();

  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  late double height;
  List<String> names = ["One Rep Max 계산기", "플레이트 바벨 계산기", "파워리프팅 강도 계산기", "Wilks 계산기"];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildCustomButton(names[index], index);
          }),
    );
  }

  Widget _buildCustomButton(String text, int index) {
    return InkWell(
      onTap: () async {
        if (index == 0)
          await showModal(index + 1, "One Rep Max 계신하기", "모든 리프트에 대한 1회당 최대 반복 수를 계산합니다", "Lift", "KG", "당신은 1RM은", "입니다");
        else if (index == 1) await showModal(index + 1, "Plate Barbell 계신하기", "바벨 리프트에 필요한 플레이트 무게를계산합니다", "Total Lift (kg)", "Bar Weight (kg)",   "당신은 Bar무게와 Plate무게를 더한 총", "를 들 수 있습니다");
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
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              )),
        ),
      ),
    );
  }

  Future<void> showModal(int mode, String title, String subtitle, String text1, String text2, String text3, String text4) async {
    await showModalBottomSheet(isScrollControlled: true, context: context, builder: (context) =>
        CalculationBottomSheet(height, title, subtitle, mode,  text1,  text2, text3, text4));
  }
}
