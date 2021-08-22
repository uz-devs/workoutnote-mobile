import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  List<String>? years = List.generate(100, (index) => "${index + 1921}");
  List<String>? months = List.generate(12, (index) => index < 9 ? "0${index + 1}" : "${index + 1}");
  List<String>? days = List.generate(31, (index) => index < 9 ? "0${index + 1}" : "${index + 1}");

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);

    print(configProvider.val);
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
            "${profileInfo[configProvider.activeLanguage()]}",
            style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Consumer<ConfigProvider>(builder: (context, provider, child) {
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
                              style: TextStyle(
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            TextFormField(
                              controller: nameController..text = configProvider.myname,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                                  ),
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
                              "${gender[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Radio(
                            //       fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(102, 51, 204, 1)),
                            //       activeColor: Color.fromRGBO(102, 51, 204, 1),
                            //       value: configProvider.g == "MALE" ? 1 : 0,
                            //       groupValue: configProvider.val,
                            //       onChanged: (int? value) {
                            //         setState(() {
                            //           if (value == 1) {
                            //             configProvider.g = "MALE";
                            //           }
                            //           configProvider.val = value!;
                            //         });
                            //       },
                            //     ),
                            //     Text("${male[configProvider.activeLanguage()]}"),
                            //     Radio(
                            //       fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(102, 51, 204, 1)),
                            //       activeColor: Color.fromRGBO(102, 51, 204, 1),
                            //       value: configProvider.g  == "FEMALE" ? 1 : 0,
                            //       groupValue: configProvider.val,
                            //       onChanged: (int? value) {
                            //         setState(() {
                            //           print("valll ${value}");
                            //           if (value == 0) {
                            //             configProvider. g = "FEMALE";
                            //           }
                            //           configProvider.val = value!;
                            //
                            //         });
                            //       },
                            //     ),
                            //     Text("${female[configProvider.activeLanguage()]}"),],
                            // )
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
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Container(
                                  height: 60,
                                  padding: EdgeInsets.all(10),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
                                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                                    ),
                                    child: DropdownButton(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(102, 51, 204, 1),
                                      ),
                                      underline: SizedBox(),
                                      value: configProvider.selectedYear,
                                      hint: Text("${year[configProvider.activeLanguage()]}"),
                                      onChanged: (item) {
                                        setState(() {
                                          configProvider.selectedYear = item.toString();
                                        });
                                      },
                                      items: years!.map((String year) {
                                        return DropdownMenuItem<String>(value: year, child: Text("$year"));
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
                                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
                                    ),
                                    child: DropdownButton(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(102, 51, 204, 1),
                                      ),
                                      value: configProvider.selectedMonth,
                                      underline: SizedBox(),
                                      hint: Text("${month[configProvider.activeLanguage()]}"),
                                      onChanged: (item) {
                                        setState(() {
                                          configProvider.selectedMonth = item.toString();
                                        });
                                      },
                                      items: months!.map((String month) {
                                        return DropdownMenuItem<String>(value: month, child: Text("$month"));
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
                                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Color.fromRGBO(102, 51, 204, 1)), borderRadius: BorderRadius.circular(25.0)),
                                    ),
                                    child: DropdownButton(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(102, 51, 204, 1),
                                      ),
                                      underline: SizedBox(),
                                      value: configProvider.selectedDay,
                                      hint: Text("${day[configProvider.activeLanguage()]}"),
                                      onChanged: (item) {
                                        setState(() {
                                          configProvider.selectedDay = item.toString();
                                        });
                                      },
                                      items: days!.map((String day) {
                                        return DropdownMenuItem<String>(value: day, child: Text("$day"));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                              "${email[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: TextFormField(
                              controller: emailController..text = userPreferences!.getString("email") ?? "",
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 5.0),
                                  hintText: "${emailHint[configProvider.activeLanguage()]}"),
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
                                style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 5.0),
                                    hintText: "${phoneNumberHint[configProvider.activeLanguage()]}"),
                              ),
                            )
                          ],
                        ),
                      );
                    else if (index == 4) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${shareSettings[configProvider.activeLanguage()]}",
                              style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            Switch(
                                activeTrackColor: Color.fromRGBO(102, 51, 204, 1),
                                activeColor: Colors.white,
                                value: configProvider.isShared,
                                onChanged: (val) {
                                  configProvider.isShared = val;
                                  setState(() {});
                                })
                          ],
                        ),
                      );
                    }

                    else  if(index == 5){
                      return Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("동의: 귀하의 데이터가 공개되어 표준을 계산하는대 사용됩니다.",  style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                          Text("비동의: 포준을 계산하는대 귀하의 데이터를 사용되지 않습니다.",  style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                        ],
                      ),);
                    }
                    else
                      return Container(
                        margin: EdgeInsets.all(15.0),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text("${update[configProvider.activeLanguage()]}"),
                            onPressed: () {
                              provider.updateProfileSettings(emailController.text, userPreferences!.getString("sessionKey") ?? "", nameController.text, configProvider.g, "${configProvider.selectedYear}-${configProvider.selectedMonth}-${configProvider.selectedDay}", configProvider.isShared).then((value) {
                                showToast("${updateToastMessage[configProvider.activeLanguage()]}");
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
                    else if (index == 1) return Container(margin: EdgeInsets.only(left: 15, right: 15), child: Divider(thickness: 1, color: Colors.grey));
                    return const Divider();
                  },
                  itemCount: 7);
            })));
  }
}
/*

 */
