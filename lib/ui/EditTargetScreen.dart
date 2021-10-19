import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/TargetProvider.dart';
import 'package:workoutnote/data/models/TargetModel.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class EditTargetScreen extends StatefulWidget {
  final Target target;

  EditTargetScreen({Key? key, required this.target}) : super(key: key);

  @override
  _EditTargetScreenState createState() => _EditTargetScreenState();
}

class _EditTargetScreenState extends State<EditTargetScreen> {
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
  void initState() {
    super.initState();
    var startDate = toDate2(widget.target.startTimestamp ?? 0);
    var endDate = toDate2(widget.target.endTimestamp ?? 0);
    selectedStartYear = startDate.split('.')[0];
    selectedStartMonth = startDate.split('.')[1];
    selectedStartDay = startDate.split('.')[2];

    selectedEndYear = endDate.split('.')[0];
    selectedEndMonth = endDate.split('.')[1];
    selectedEndDay = endDate.split('.')[2];
    targetNameTextEditingController.text = widget.target.targetName!;
  }

  @override
  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context);
    targetProvider = Provider.of<TargetProvider>(context);

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color.fromRGBO(102, 51, 204, 1)), onPressed: () => Navigator.of(context).pop()), backgroundColor: Colors.white, title: Text('${editTarget[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.black))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          // _emailController.clear();
                        },
                        icon: Icon(Icons.close),
                        color: Color.fromRGBO(102, 51, 204, 1),
                      ),
                      contentPadding: EdgeInsets.only(left: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
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
                Container(
                    margin: EdgeInsets.only(left: 15.0, top: 25.0),
                    child: Text(
                      '${targetSuccess[configProvider.activeLanguage()]}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        color: widget.target.achieved ? Color.fromRGBO(102, 51, 204, 1) : Colors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                        child: Text('${achieved[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16)),
                        onPressed: () => setState(() => widget.target.achieved = true),
                      ),
                      CupertinoButton(
                        color: !widget.target.achieved ? Color.fromRGBO(102, 51, 204, 1) : Colors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                        child: Text('${notAchieved[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16)),
                        onPressed: () => setState(() => widget.target.achieved = false),
                      ),
                    ],
                  ),
                ),
                Container(height: 50),
                Center(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(30),
                    child: CupertinoButton(
                        color: Color.fromRGBO(102, 51, 204, 1),
                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                        child: Text('${update[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16)),
                        padding: EdgeInsets.all(16),
                        onPressed: () {
                          showLoadingDialog(context);
                          targetProvider.editTarget(widget.target.id ?? -1, targetNameTextEditingController.text, '${selectedStartYear}-${selectedStartMonth}-${selectedStartDay}', '${selectedEndYear}-${selectedEndMonth}-${selectedEndDay}', widget.target.achieved).then((value) {
                            Navigator.pop(context);
                            switch (value) {
                              case SUCCESS:
                                showSnackBar('${targetEditSuccess[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);
                                break;
                              case SOCKET_EXCEPTION:
                                showSnackBar('${socketException[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                break;
                              case MISC_EXCEPTION:
                                showSnackBar('${unexpectedError[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                break;
                              default:
                                break;
                            }
                          });
                        }),
                  ),
                ),
              ],
            ),
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
                icon: Center(child: Icon(Icons.arrow_drop_down, color: Color.fromRGBO(102, 51, 204, 1))),
                underline: SizedBox(),
                value: selectedStartYear,
                hint: Text('${year[configProvider.activeLanguage()]}'),
                onChanged: (item) => setState(() => selectedStartYear = item.toString()),
                items: years!.map((String year) => DropdownMenuItem<String>(value: year, child: Text('$year'))).toList(),
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
                icon: Center(child: Icon(Icons.arrow_drop_down, color: Color.fromRGBO(102, 51, 204, 1))),
                value: selectedStartMonth,
                underline: SizedBox(),
                hint: Text('${month[configProvider.activeLanguage()]}'),
                onChanged: (item) => setState(() => selectedStartMonth = item.toString()),
                items: months!.map((String month) => DropdownMenuItem<String>(value: month, child: Text('$month'))).toList(),
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
                icon: Center(child: Icon(Icons.arrow_drop_down, color: Color.fromRGBO(102, 51, 204, 1))),
                underline: SizedBox(),
                value: selectedStartDay,
                hint: Text('${day[configProvider.activeLanguage()]}'),
                onChanged: (item) => setState(() => selectedStartDay = item.toString()),
                items: days!.map((String day) => DropdownMenuItem<String>(value: day, child: Text('$day'))).toList(),
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
                icon: Center(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(102, 51, 204, 1),
                  ),
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
                icon: Center(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(102, 51, 204, 1),
                  ),
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
                icon: Center(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(102, 51, 204, 1),
                  ),
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

  Future<void> _showDeleteConfirmDialog() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: 186.2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 8,
                      child: Container(
                        margin: EdgeInsets.only(left: 50.0, right: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${deleteMessage[configProvider.activeLanguage()]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Divider(),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                '${deleteCancel[configProvider.activeLanguage()]}',
                                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text('${deleteYes[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.red, fontSize: 18)),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}
