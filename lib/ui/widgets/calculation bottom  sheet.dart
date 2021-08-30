import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculationBottomSheet extends StatefulWidget {
  final height;
  final title;
  final subtitle;
  final mode;
  final text1;
  final text2;
  final text3;
  final text4;

  CalculationBottomSheet(this.height, this.title, this.subtitle, this.mode,
      this.text1, this.text2, this.text3, this.text4);

  @override
  _CalculationBottomSheetState createState() => _CalculationBottomSheetState();
}

class _CalculationBottomSheetState extends State<CalculationBottomSheet> {
  double currentRM = 0.0;
  var textController1 = TextEditingController();
  var textController2 = TextEditingController();

  List<int> reps = List.generate(51, (index) => (index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: widget.height,
          child: SafeArea(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 0)
                    return Container(
                        margin: EdgeInsets.only(top: 20.0),
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                        ));
                  else if (index == 1)
                    return Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 20.0),
                        child: Text(
                          "${widget.title}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ));
                  else if (index == 2)
                    return Container(
                        margin: EdgeInsets.only(left: 20.0),
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "${widget.subtitle}",
                          style: TextStyle(fontSize: 15),
                        ));
                  else if (index == 3)
                    return _buildCalculationWidget();
                  else if (index == 4) {
                    return Container(
                      padding: EdgeInsets.only(top: 10.0),
                      margin: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "${widget.text3}",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "$currentRM",
                                  style: TextStyle(
                                      fontSize: 42.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(102, 51, 204, 1))),
                              TextSpan(text: "  "),
                              TextSpan(
                                  text: "kg",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26)),
                              TextSpan(text: "  "),
                              TextSpan(
                                  text: "${widget.text4}",
                                  style: TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    );
                  }
                }),
          )),
    );
  }

  Widget _buildCalculationWidget() {
    return Container(
      height: 280,
      margin: EdgeInsets.all(10.0),
      child: Card(
        color: Color.fromRGBO(102, 51, 204, 1),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "${widget.text1}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                )),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (c) async {},
                controller: textController2,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  hintText: "직접 입력",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(width: 1.5, color: Colors.white)),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20.0),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "${widget.text2}",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                controller: textController1,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (c) async {},
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  hintText: "직접 입력",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(width: 1.5, color: Colors.white)),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0),
              child: CupertinoButton(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(120)),
                  child: Text(
                    "계산하기",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(102, 51, 204, 1)),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    _calculateRM();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateRM() {
    var kg = double.parse(textController1.text);
    var rep = double.parse(textController2.text);
    setState(() {
      currentRM = kg + kg * rep * 0.025;
    });
  }

  void _calculateBarbell() {}
}
