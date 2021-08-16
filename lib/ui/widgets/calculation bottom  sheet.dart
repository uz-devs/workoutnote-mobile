import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculationBottomSheet extends StatefulWidget {
  final height;


  CalculationBottomSheet(this.height);

  @override
  _CalculationBottomSheetState createState() => _CalculationBottomSheetState();
}

class _CalculationBottomSheetState extends State<CalculationBottomSheet> {
  int selectedVal1 = 1;
  int selectedVal2 = 1;
  double  currentRM = 0.0;
  List<int> reps = List.generate(51, (index) => (index));

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height - MediaQueryData.fromWindow(window).padding.top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0,),
              child: Text(
                "MASS",
                style: TextStyle(fontSize: 20, color: Color.fromRGBO(102, 51, 204, 1)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),

              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: EdgeInsets.only(left: 20.0, right: 10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedVal1,
                    onChanged: (val) {
                      setState(() {
                        selectedVal1 = val!;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(102, 51, 204, 1),
                    ),
                    items: reps.map((e) {
                      return DropdownMenuItem<int>(value: e, child: Text("${e} KG"));
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0,),

              child: Text(
                "REP",
                style: TextStyle(fontSize: 20, color: Color.fromRGBO(102, 51, 204, 1)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),

              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: EdgeInsets.only(left: 20.0, right: 10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedVal2,
                    onChanged: (val) {
                      setState(() {
                        selectedVal2 = val!;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(102, 51, 204, 1),
                    ),
                    items: reps.map((e) {
                      return DropdownMenuItem<int>(value: e, child: Text("$e"));
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(10.0),
              child: CupertinoButton(
                color: Color.fromRGBO(102, 51, 204, 1),
                onPressed: (){
                  _calculateRM();
                },
                child:Text("Calculate",  style: TextStyle(color: Colors.white),),

              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10.0),
              child: Text("Your  RM is ${currentRM}", style: TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),),
            )
          ],
        ));
  }

  void _calculateRM(){
    setState(() {
      currentRM = selectedVal1 + selectedVal1 * selectedVal2 * 0.025;
    });
  }
}
