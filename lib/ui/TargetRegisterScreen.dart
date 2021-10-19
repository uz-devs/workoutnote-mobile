import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/TargetProvider.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class TargetRegistrationScreen extends StatefulWidget {
  const TargetRegistrationScreen({Key? key}) : super(key: key);

  @override
  _TargetRegistrationScreenState createState() => _TargetRegistrationScreenState();
}

class _TargetRegistrationScreenState extends State<TargetRegistrationScreen> {
  var configProvider = ConfigProvider();
  var targetProvider = TargetProvider();
  List<String>? years = List.generate(10, (index) => '${index + DateTime.now().year}');
  List<String>? months = List.generate(12, (index) => index < 9 ? '0${index + 1}' : '${index + 1}');
  List<String>? days = List.generate(31, (index) => index < 9 ? '0${index + 1}' : '${index + 1}');

  //textField
  var targetNameTextEditingController = TextEditingController();

  //date fields
  String? selectedStartDay;
  String? selectedStartMonth;
  String? selectedStartYear;
  String? selectedEndDay;
  String? selectedEndMonth;
  String? selectedEndYear;

  @override
  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context);
    targetProvider = Provider.of<TargetProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(102, 51, 204, 1),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '${registerPlan[configProvider.activeLanguage()]}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  )))
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 15.0, top: 25.0),
                  child: Text(
                    '${planName[configProvider.activeLanguage()]}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                  )),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                child: TextFormField(
                  controller: targetNameTextEditingController,
                  cursorColor: Color.fromRGBO(102, 51, 204, 1),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                    hintText: '직접 입력',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        targetNameTextEditingController.clear();
                      },
                      icon: Icon(Icons.close),
                      color: Color.fromRGBO(102, 51, 204, 1),
                    ),
                    contentPadding: EdgeInsets.only(left: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(102, 51, 204, 1),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 15.0, top: 25.0),
                  child: Text(
                    '${startDate[configProvider.activeLanguage()]}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                  )),
              _buildStartDateRow(),
              Container(
                  margin: EdgeInsets.only(left: 15.0, top: 25.0),
                  child: Text(
                    '${endDate[configProvider.activeLanguage()]}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                  )),
              _buildEndDateRow(),
              Spacer(),
              Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
                  child: CupertinoButton(
                      color: Color.fromRGBO(102, 51, 204, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(120)),
                      child: Text('${registerPlan[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        showLoadingDialog(context);
                        targetProvider.registerTarget(targetNameTextEditingController.text, '${selectedStartYear}-${selectedStartMonth}-${selectedStartDay}', '${selectedEndYear}-${selectedEndMonth}-${selectedEndDay}').then((value) {
                          Navigator.pop(context);
                          switch (value) {
                            case SUCCESS:
                              {
                                showSnackBar('${targetRegisterSuccess[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);
                              }
                              break;
                            case SOCKET_EXCEPTION:
                              {
                                showSnackBar('${socketException[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                              }
                              break;
                            case MISC_EXCEPTION:
                              {
                                showSnackBar('${unexpectedError[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                              }
                              break;
                            default:
                              {}
                          }
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                underline: SizedBox(),
                value: selectedStartYear,
                hint: Text('${year[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedStartYear = item.toString();
                  });
                },
                items: years!.map((String year) {
                  return DropdownMenuItem<String>(value: year, child: Text('$year'));
                }).toList(),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                value: selectedStartMonth,
                underline: SizedBox(),
                hint: Text('${month[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedStartMonth = item.toString();
                  });
                },
                items: months!.map((String month) {
                  return DropdownMenuItem<String>(value: month, child: Text('$month'));
                }).toList(),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                underline: SizedBox(),
                value: selectedStartDay,
                hint: Text('${day[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedStartDay = item.toString();
                  });
                },
                items: days!.map((String day) {
                  return DropdownMenuItem<String>(value: day, child: Text('$day'));
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                underline: SizedBox(),
                value: selectedEndYear,
                hint: Text('${year[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedEndYear = item.toString();
                  });
                },
                items: years!.map((String year) {
                  return DropdownMenuItem<String>(value: year, child: Text('$year'));
                }).toList(),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                value: selectedEndMonth,
                underline: SizedBox(),
                hint: Text('${month[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedEndMonth = item.toString();
                  });
                },
                items: months!.map((String month) {
                  return DropdownMenuItem<String>(value: month, child: Text('$month'));
                }).toList(),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
              ),
              child: DropdownButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(102, 51, 204, 1),
                ),
                underline: SizedBox(),
                value: selectedEndDay,
                hint: Text('${day[configProvider.activeLanguage()]}'),
                onChanged: (item) {
                  setState(() {
                    selectedEndDay = item.toString();
                  });
                },
                items: days!.map((String day) {
                  return DropdownMenuItem<String>(value: day, child: Text('$day'));
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
