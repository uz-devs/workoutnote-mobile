import 'dart:ui';

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class CalculationBottomSheet extends StatefulWidget {
  final height;
  final title;
  final subtitle;
  final mode;
  final text1;
  final text2;
  final text3;
  final text4;

  CalculationBottomSheet(this.height, this.title, this.subtitle, this.mode, this.text1, this.text2, this.text3, this.text4);

  @override
  _CalculationBottomSheetState createState() => _CalculationBottomSheetState();
}

class _CalculationBottomSheetState extends State<CalculationBottomSheet> {
  double currentRM = 0.0;
  String wilksCoeff = '0.0';
  List<Map<int, double>> currentPlateBarbellKG = [];
  var textController1 = TextEditingController();
  var textController2 = TextEditingController();
  var bodyWeightController = TextEditingController();
  var configProvider = ConfigProvider();

  //Plate Barbell calculation
  List<int> plateNumberList = List.generate(10, (index) => index + 1);
  List<int> dropDownValues = [1, 1, 1, 1, 1, 1];
  List<double> plates = [25, 20, 15, 10, 5, 2.5];
  List<double> qty = [0, 10, 10, 10, 10, 10];
  //Wilks  relates stuff
  String currentGender = wilksGender[0][english] ?? 'None';
  List<String?> genders = [];

  var mA = -216.0475144;
  var mB = 16.2606339;
  var mC = -0.002388645;
  var mD = -0.00113732;
  var mE = 7.01863E-06;
  var mF = -1.291E-08;
  var fA = 594.31747775582;
  var fB = -27.23842536447;
  var fC = 0.82112226871;
  var fD = -0.00930733913;
  var fE = 4.731582E-05;
  var fF = -9.054E-08;

  @override
  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context, listen: false);
    genders = [wilksGender[0][configProvider.activeLanguage()]!, wilksGender[1][configProvider.activeLanguage()]!, wilksGender[2][configProvider.activeLanguage()]!];

    var list = customList(double.parse(textController1.text.isNotEmpty ? textController1.text : '0'));

    var count;

    if (widget.mode == 1) {
      count = 13;
    }
    else if  (widget.mode == 2){
      count = 12 + currentPlateBarbellKG.length;

    }
    else {
      count = 6;
    }
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: widget.height,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (context, index) {
              if (index == 0)
                return Container(
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
                      '${widget.title}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ));
              else if (index == 2)
                return Container(
                    margin: EdgeInsets.only(left: 20.0),
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Text(
                        '${widget.subtitle}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ));
              else if (index == 3)
                return _buildCalculationWidget();
              else if (index == 4) {
                return Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Text(
                    '${widget.text3}',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                );
              } else if ((index > 4 && index < count - 7) || (index == 5 && widget.mode == 4) || (index == 5 && widget.mode == 1)) {

                print('current mode is ${widget.mode}');

                if (widget.mode == 1)
                  return Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 14.0, color: Colors.black), children: [
                        TextSpan(text: '$currentRM', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1))),
                        TextSpan(text: '  '),
                        TextSpan(text: 'kg', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black26)),
                        TextSpan(text: '  '),
                        TextSpan(
                            text: '${widget.text4}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  );
                else if (widget.mode == 2 && currentPlateBarbellKG.isNotEmpty) {
                  index = index - 5;
                  return Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 14.0, color: Colors.black), children: [
                        TextSpan(text: '${currentPlateBarbellKG[index].values.single} x ${currentPlateBarbellKG[index].keys.single}', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1))),
                        TextSpan(text: '  '),
                        TextSpan(text: 'kg ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black26)),
                        TextSpan(text: '  '),
                        TextSpan(
                            text: '${widget.text4}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  );
                }
                else if (widget.mode == 4)
                  return Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 14.0, color: Colors.black), children: [
                        TextSpan(text: '$wilksCoeff', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1))),
                        TextSpan(text: '  '),
                        TextSpan(
                            text: '${widget.text4}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  );
                else
                  return Container();
              } else if (index == count - 7) {
                print('heeeee');
                if (widget.mode == 1)
                  return Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${oneRepMax7[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(119, 119, 119, 1)),
                        ),
                        Text(
                          '${oneRepMax8[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(119, 119, 119, 1)),
                        ),
                      ],
                    ),
                  );
                else if (widget.mode == 2) {
                  return Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${plateBarbell7[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(119, 119, 119, 1)),
                        ),
                        Text(
                          '${plateBarbell8[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(119, 119, 119, 1)),
                        ),
                      ],
                    ),
                  );
                } else
                  return Container();
              }
              else {



                if (widget.mode == 1) {
                  index = index  - 7;
                  print('index  ${index}');
                  return _buildCustomRow(list[index].keys.single, list[index].values.single, int.parse(textController2.text.isNotEmpty ? textController2.text : '0'), index);
                }
                else if (widget.mode == 2) {
                  index = index - (6 + currentPlateBarbellKG.length);
                  return _buildCustomRow(list[index].keys.single, list[index].values.single, -1, index);
                } else
                  return Container();
              }
            }),
      );

  }

  //Widgets
  Widget _buildCustomRow(double percentage, double mass, int repNumber, int index) {
    switch (widget.mode) {
      case 1:
        return Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              percentage == 100
                  ? Text(
                      '${percentage}%\t\t\t\t\t\t\t\t\t\t\t${mass} kg',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      '${percentage}%\t\t\t\t\t\t\t\t\t\t\t\t\t${mass} kg',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              RichText(text: TextSpan(children: [TextSpan(text: '${repNumber}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), TextSpan(text: 'Repeti', style: TextStyle(color: Colors.transparent))]))
            ],
          ),
        );
      case 2:
        return Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${percentage}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: configProvider.activeLanguage() == english ? 20 : 0.0),
                  child: DropdownButton<int>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: dropDownValues[index],
                      onChanged: (newValue) async {
                        setState(() {
                          dropDownValues[index] = newValue!;
                        });
                      },
                      items: plateNumberList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('${value}', style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList()),
                )
              ],
            ));
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return Container();
    }
  }

  Widget _buildCalculationWidget() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        color: Color.fromRGBO(102, 51, 204, 1),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: widget.mode == 1 || widget.mode == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 31.0, top: 28.0, bottom: 10.0),
                      child: Text(
                        '${widget.text1}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 31.0, right: 31.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      keyboardType: TextInputType.number,
                      onChanged: (c) async {},
                      controller: textController2,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                        hintText: '${enterNumber[configProvider.activeLanguage()]}',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14.0),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 31.0, top: 20.0, bottom: 10.0),
                      child: Text(
                        '${widget.text2}',
                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 31.0, right: 31.0),
                    child: TextFormField(
                      controller: textController1,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      keyboardType: TextInputType.number,
                      onChanged: (c) async {},
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                        hintText: '${enterNumber[configProvider.activeLanguage()]}',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 30.0, top: 30),
                    child: CupertinoButton(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                        child: Text(
                          '${calculate[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                        onPressed: () {
                          if (widget.mode == 1 || widget.mode == 2) {
                            if (textController2.text.isNotEmpty && textController1.text.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              if (widget.mode == 1)
                                _calculateRM();
                              else if (widget.mode == 2) {
                                _calculatePlateBarbell();
                              }
                            } else {
                              showToast('${emptyTextField[configProvider.activeLanguage()]}');
                            }
                          }
                        }),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 31.0, top: 28.0, bottom: 10.0),
                      child: Text(
                        'Body weight',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 31.0, right: 31.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      keyboardType: TextInputType.number,
                      onChanged: (c) {},
                      controller: bodyWeightController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                        hintText: '${enterNumber[configProvider.activeLanguage()]}',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14.0),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 31.0, top: 28.0, bottom: 10.0),
                      child: Text(
                        '${widget.text1}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 31.0, right: 31.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      keyboardType: TextInputType.number,
                      onChanged: (c) {},
                      controller: textController2,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                        hintText: '${enterNumber[configProvider.activeLanguage()]}',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14.0),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 31.0, top: 20.0, bottom: 10.0),
                      child: Text(
                        '${widget.text2}',
                        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 31.0, right: 31.0),
                      width: 300,
                      height: 80,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.white), borderRadius: BorderRadius.circular(15.0)),
                          contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                        ),
                        child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            isExpanded: true,
                            selectedItemBuilder: (BuildContext context){
                              return  genders.map( (String? value) {
                                 return  Container(
                                     alignment: Alignment.centerLeft,

                                     child: Text('$value', style:  TextStyle(color:  Colors.white, fontWeight: FontWeight.bold),  textAlign: TextAlign.center,));
                              }).toList();
                            },
                            underline: SizedBox(),
                            value: currentGender,
                            onChanged: (newValue) {
                              setState(() {
                                currentGender = newValue!;
                              });
                            },
                            items: genders.map((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('${value}', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            }).toList()),
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: CupertinoButton(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                        child: Text(
                          '${calculate[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                        onPressed: () {
                          if (bodyWeightController.text.isNotEmpty && textController2.text.isNotEmpty && currentGender != 'None') {
                            print('georugqoeur');
                            FocusScope.of(context).unfocus();
                            _calculateWilks();
                          } else {
                            showToast('${emptyTextField[configProvider.activeLanguage()]}');
                          }
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  //mode = 1
  void _calculateRM() {
    var kg = double.parse(textController1.text);
    var rep = double.parse(textController2.text);
    setState(() {
      currentRM = kg + kg * rep * 0.025;
    });
  }

  //mode = 2
  void _calculatePlateBarbell() {
    currentPlateBarbellKG.clear();
    var totalKG = double.parse(textController2.text);
    var barKG = double.parse(textController1.text);

    if (barKG < totalKG) {
      var temp1 = (totalKG - barKG) ~/ 2;
      for (int i = 0; i < plates.length; i++) {
        if (temp1 % plates[i] == 0 && temp1 / plates[i] <= dropDownValues[i] && temp1 / plates[i] != 0) {
          currentPlateBarbellKG.add({temp1 ~/ plates[i]: plates[i]});
        }
      }
      if (currentPlateBarbellKG.isEmpty) {
        showToast('Plate Barbell cannot  be  calculated!');
      }
    } else {
      showToast('Total Lift cannot be less than Bar weight!');
    }
    setState(() {});
  }

  //mode == 4
  void _calculateWilks() {
    var bodyWeight = double.parse(bodyWeightController.text);
    var liftWeight = double.parse(textController2.text);
    if (currentGender == wilksGender[2][configProvider.activeLanguage()]) {
      setState(() {
        wilksCoeff = (liftWeight * 500 / (fA + fB * pow(bodyWeight, 1) + fC * pow(bodyWeight, 2) + fD * pow(bodyWeight, 3) + fE * pow(bodyWeight, 4) + fF * pow(bodyWeight, 5))).toStringAsPrecision(4);

        print(wilksCoeff);
      });
    } else if (currentGender == wilksGender[1][configProvider.activeLanguage()]) {
      setState(() {
        wilksCoeff = (liftWeight * 500 / (mA + mB * pow(bodyWeight, 1) + mC * pow(bodyWeight, 2) + mD * pow(bodyWeight, 3) + mE * pow(bodyWeight, 4) + mF * pow(bodyWeight, 5))).toStringAsPrecision(4);
        print(wilksCoeff);
      });
    }
  }

  //utils
  List<Map<double, double>> customList(double mass) {
    switch (widget.mode) {
      case 1:
        {
          List<Map<double, double>> masses = [];
          double p = 100;

          for (int i = 0; i < 6; i++) {
            masses.add({p: mass * p / 100});
            p = p - 5;
          }
          return masses;
        }

      case 2:
        {
          List<Map<double, double>> availableOptions = [];
          for (int i = 0; i < 6; i++) {
            availableOptions.add({plates[i]: -1});
          }

          return availableOptions;
        }

      case 3:
        {
          return [];
        }

      case 4:
        {
          return [];
        }

      default:
        return [];
    }
  }
}
