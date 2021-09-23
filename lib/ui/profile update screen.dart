import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';

import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen();

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  List<String>? years = List.generate(100, (index) => '${index + 1921}');
  List<String>? months = List.generate(12, (index) => index < 9 ? '0${index + 1}' : '${index + 1}');
  List<String>? days = List.generate(31, (index) => index < 9 ? '0${index + 1}' : '${index + 1}');

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);









    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromRGBO(102, 51, 204, 1),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            '${profileInfo[configProvider.activeLanguage()]}',
            style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
          ),
        ),
        body: Container(
            child: Consumer<ConfigProvider>(builder: (context, provider, child) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) return Container(
                        margin: const EdgeInsets.only(left: 28.0, right: 28.0, top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${name[configProvider.activeLanguage()]}',
                              style: TextStyle(
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                                ),
                              ),
                              child: TextFormField(
                                cursorColor: Color.fromRGBO(102, 51, 204, 1),
                                controller: nameController..text = configProvider.myname,
                                decoration: InputDecoration(

                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5.0, bottom :5.0),
                                    hintText: '${nameHint[configProvider.activeLanguage()]}'),
                              ),
                            )
                          ],
                        ),
                      );
                    else if (index == 1) return Container(
                        margin: EdgeInsets.only(left: 28.0, top: 10, right: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${gender[configProvider.activeLanguage()]}',
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            Container(

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(

                                    fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(102, 51, 204, 1)),
                                    activeColor: Color.fromRGBO(102, 51, 204, 1),
                                    value: 1,
                                    groupValue: configProvider.val,
                                    onChanged: (int? value) {

                                      setState(() {
                                        if (value == 1) {
                                          configProvider.g = 'MALE';
                                        }
                                        configProvider.val = value!;
                                      });
                                    },
                                  ),
                                  Text('${male[configProvider.activeLanguage()]}'),
                                  Radio(
                                    fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(102, 51, 204, 1)),
                                    activeColor: Color.fromRGBO(102, 51, 204, 1),
                                    value: 0,
                                    groupValue: configProvider.val,
                                    onChanged: (int? value) {
                                      setState(() {
                                        if (value == 0) {
                                          configProvider. g = 'FEMALE';
                                        }
                                        configProvider.val = value!;
                                      });
                                    },
                                  ),
                                  Text('${female[configProvider.activeLanguage()]}'),],
                              ),
                            )
                          ],
                        ),
                      );
                    else if (index == 2) return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 28, top: 10,  right: 28),
                            child: Text(
                              '${birthDate[configProvider.activeLanguage()]}',
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 28, top: 10,  right: 28),

                            child: Row(
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
                                        value: configProvider.selectedYear,
                                        hint: Text('${year[configProvider.activeLanguage()]}'),
                                        onChanged: (item) {
                                          setState(() {
                                            configProvider.selectedYear = item.toString();
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
                                        value: configProvider.selectedMonth,
                                        underline: SizedBox(),
                                        hint: Text('${month[configProvider.activeLanguage()]}'),
                                        onChanged: (item) {
                                          setState(() {
                                            configProvider.selectedMonth = item.toString();
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
                                        value: configProvider.selectedDay,
                                        hint: Text('${day[configProvider.activeLanguage()]}'),
                                        onChanged: (item) {
                                          setState(() {
                                            configProvider.selectedDay = item.toString();
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
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 28, top: 28),
                            child: Text(
                              '${email[configProvider.activeLanguage()]}',
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 28.0, right: 28.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: Color.fromRGBO(102, 51, 204, 1),

                              controller: emailController..text = userPreferences!.getString('email') ?? '',
                              decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  hintText: '${emailHint[configProvider.activeLanguage()]}'),
                            ),
                          )
                        ],
                      );
                    else if (index == 3) return Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 28, right: 28),
                              child: Text(
                                '${phoneNumber[configProvider.activeLanguage()]}',
                                style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left:28.0, right:28.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Color.fromRGBO(102, 51, 204, 1)),
                                ),
                              ),
                              child: TextFormField(
                                cursorColor: Color.fromRGBO(102, 51, 204, 1),

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    hintText: '${phoneNumberHint[configProvider.activeLanguage()]}'),
                              ),
                            )
                          ],
                        ),
                      );
                    else if (index == 4) {
                      return Container(
                        margin: EdgeInsets.only(left: 28.0,  right: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${shareSettings[configProvider.activeLanguage()]}',
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            FlutterSwitch(
                              valueFontSize: 10,
                                showOnOff: true,
                              activeText: '${accept[configProvider.activeLanguage()]}'
                                ,

                                inactiveText: '',
                                activeTextColor: Colors.white,
                                activeColor: Color.fromRGBO(102, 51, 204, 1),
                                value: configProvider.isShared,
                                onToggle: (val) {
                                  configProvider.isShared = val;
                                  setState(() {});
                                })
                          ],
                        ),
                      );
                    }
                    else  if(index == 5){
                      return Container(
                        margin: EdgeInsets.only(left: 28.0, right: 28.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${agree[configProvider.activeLanguage()]}',  style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                          Text('${disagree[configProvider.activeLanguage()]}',  style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                        ],
                      ),);
                    }
                    else return Container(
                        margin: EdgeInsets.only(left: 28.0, right: 28.0, top: 15.0, bottom: 15.0),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text('${update[configProvider.activeLanguage()]}'),
                            onPressed: () {
                              provider.updateProfileSettings(emailController.text, userPreferences!.getString('sessionKey') ?? '', nameController.text, configProvider.g, '${configProvider.selectedYear}-${configProvider.selectedMonth}-${configProvider.selectedDay}', configProvider.isShared).then((value) {

                                showSnackBar('${updateToastMessage[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);

                                //showToast('${updateToastMessage[configProvider.activeLanguage()]}');
                              });
                            }),
                      );
                  },
                  separatorBuilder: (context, index) {
                    if (index == 0 || index == 2 || index == 3 || index == 4 || index == 5)
                      return Divider(
                        thickness: 0,
                        color: Colors.white,
                      );
                    else if (index == 1) return Container(margin: EdgeInsets.only(left: 28.0, right:28.0), child: Divider(
                        height:  1,
                        thickness: 1, color: Color.fromRGBO(102, 51, 204, 1)));
                    return const Divider();
                  },
                  itemCount: 7);
            })));
  }
}

