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
     height  = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: ListView.builder(itemCount: 4,   itemBuilder: (context, index){
         return _buildCustomButton(names[index]);
      }),
    );
  }

  Widget _buildCustomButton(String text){

    return  InkWell(
      onTap: ()  async{
        await showModal();
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
              child: Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white),)),
        ),
      ),
    );
  }

  Future<void> showModal() async {
     await  showModalBottomSheet(
         isScrollControlled: true,
         context: context, builder: (context) => CalculationBottomSheet(height));
  }
}
