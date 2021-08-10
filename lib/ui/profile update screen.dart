import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/user%20management%20%20provider.dart';

import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen();

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  var nameController = TextEditingController();
  String gender = "MALE";
  List<String>? years = List.generate(100, (index) => "${index + 1921}");
  List<String>? months = List.generate(12, (index) => "${index + 1}");
  List<String>? days = List.generate(30, (index) => "${index + 2}");
  String? selectedYear, selectedMonth, selectedDay;
  int _val = 1;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.deepPurpleAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            "${profileInfo[configProvider.activeLanguage()]}",
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child:
                Consumer<UserManagement>(builder: (context, provider, child) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${name[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            TextFormField(
                              controller: nameController..text = userPreferences!.getString("name") ?? "",
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 5.0),
                                  hintText: "${nameHint[configProvider.activeLanguage()]}"),
                            )
                          ],
                        ),
                      );
                    else if (index == 1)
                      return Container(
                        margin: EdgeInsets.only(left: 15.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  activeColor: Colors.deepPurpleAccent,
                                  value: userPreferences!.getString("gender") ==
                                          "MALE"
                                      ? 1
                                      : 0,
                                  groupValue: _val,
                                  onChanged: (int? value) {
                                    setState(() {
                                      if (value == 1) {
                                        print("male");
                                        gender = "MALE";
                                      }
                                      _val = value!;
                                    });
                                  },
                                ),
                                Text(
                                    "${male[configProvider.activeLanguage()]}"),
                                Radio(
                                  activeColor: Colors.deepPurpleAccent,
                                  value: userPreferences!.getString("gender") ==
                                          "FEMALE"
                                      ? 1
                                      : 0,
                                  groupValue: _val,
                                  onChanged: (int? value) {
                                    print(value);
                                    setState(() {
                                      if (value == 0) {
                                        print("female");
                                        gender = "FEMALE";
                                      }
                                      _val = value!;
                                    });
                                  },
                                ),
                                Text(
                                    "${female[configProvider.activeLanguage()]}"),
                              ],
                            )
                          ],
                        ),
                      );
                    else if (index == 2)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                              "${birthDate[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropdownButton(
                                underline: SizedBox(),
                                value: selectedYear,
                                hint: Text(
                                    "${year[configProvider.activeLanguage()]}"),
                                onChanged: (item) {
                                  setState(() {
                                    selectedYear = item.toString();
                                  });
                                },
                                items: years!.map((String year) {
                                  return DropdownMenuItem<String>(
                                      value: year, child: Text("$year"));
                                }).toList(),
                              ),
                              DropdownButton(
                                value: selectedMonth,
                                underline: SizedBox(),
                                hint: Text(
                                    "${month[configProvider.activeLanguage()]}"),
                                onChanged: (item) {
                                  setState(() {
                                    selectedMonth = item.toString();
                                  });
                                },
                                items: months!.map((String month) {
                                  return DropdownMenuItem<String>(
                                      value: month, child: Text("$month"));
                                }).toList(),
                              ),
                              DropdownButton(
                                underline: SizedBox(),
                                value: selectedDay,
                                hint: Text(
                                    "${day[configProvider.activeLanguage()]}"),
                                onChanged: (item) {
                                  setState(() {
                                    selectedDay = item.toString();
                                  });
                                },
                                items: days!.map((String day) {
                                  return DropdownMenuItem<String>(
                                      value: day, child: Text("$day"));
                                }).toList(),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                              "${email[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: TextFormField(
                              controller: TextEditingController()
                                ..text = userPreferences!.getString("email") ?? "",
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 5.0),
                                  hintText:
                                      "${emailHint[configProvider.activeLanguage()]}"),
                            ),
                          )
                        ],
                      );
                    else if (index == 3)
                      return Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "${phoneNumber[configProvider.activeLanguage()]}",
                                style:
                                    TextStyle(color: Colors.deepPurpleAccent),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5.0),
                                    hintText:
                                        "${phoneNumberHint[configProvider.activeLanguage()]}"),
                              ),
                            )
                          ],
                        ),
                      );
                    else
                      return Container(
                        margin: EdgeInsets.all(15.0),
                        child: CupertinoButton(
                            color: Colors.deepPurpleAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(120)),
                            child: Text(
                                "${update[configProvider.activeLanguage()]}"),
                            onPressed: () {
                              provider
                                  .updateProfileSettings(
                                      userPreferences!
                                              .getString("sessionKey") ??
                                          "",
                                      nameController.text,
                                      gender)
                                  .then((value) {
                                showToast(
                                    "${updateToastMessage[configProvider.activeLanguage()]}");
                              });
                            }),
                      );
                  },
                  separatorBuilder: (context, index) {
                    if (index == 0 || index == 2 || index == 3)
                      return Divider(
                        thickness: 0,
                        color: Colors.white,
                      );
                    else if (index == 1)
                      return Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Divider(
                            color: Colors.deepPurpleAccent,
                          ));
                    return const Divider();
                  },
                  itemCount: 5);
            })));
  }
}
