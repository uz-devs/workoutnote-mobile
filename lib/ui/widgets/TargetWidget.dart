import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/TargetProvider.dart';
import 'package:workoutnote/data/models/TargetModel.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import '../EditTargetScreen.dart';
import '../TargetsScreen.dart';

class TargetWidget extends StatelessWidget {
  final Target target;
  var configProvider = ConfigProvider();
  var targetProvider = TargetProvider();

  TargetWidget({Key? key, required this.target}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    targetProvider = Provider.of<TargetProvider>(context);
    configProvider = Provider.of<ConfigProvider>(context);

    return Container(
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: !targetProvider.isTargetPassed(target)
                        ? Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: Text(
                              target.targetName!.length > 10 ? '${target.targetName!.substring(0, 9)}...' : '${target.targetName}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: targetProvider.isTargetPassed(target) ? Colors.grey : Colors.black),
                            ),
                          )
                        : Row(
                            children: [
                              IconButton(
                                alignment: Alignment.bottomCenter,
                                onPressed: () {
                                  targetProvider.toggleTarget(target.id ?? -1).then((value) {
                                    if (value == SOCKET_EXCEPTION) {
                                      showSnackBar('${socketException[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                    } else if (value == MISC_EXCEPTION) {
                                      showSnackBar('${unexpectedError[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                    }
                                  });
                                },
                                icon: Icon(
                                  target.achieved ? Icons.check_circle : Icons.remove_circle_outlined,
                                  color: target.achieved ? Colors.green : Colors.red,
                                ),
                              ),
                              Text(
                                target.targetName!.length > 10 ? '${target.targetName!.substring(0, 9)}...' : '${target.targetName}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: targetProvider.isTargetPassed(target) ? Colors.grey : Colors.black),
                              )
                            ],
                          )),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: !targetProvider.isTargetPassed(target)
                        ? Text(
                            targetProvider.getNthDate(target.endTimestamp ?? 0) >= 0 ? 'D-${targetProvider.getNthDate(target.endTimestamp ?? 0)}' : 'N.S',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            target.achieved ? '${achieved[configProvider.activeLanguage()]}' : '${notAchieved[configProvider.activeLanguage()]}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                    color: targetProvider.isTargetPassed(target) ? Colors.grey : Color.fromRGBO(102, 51, 204, 1),
                  ),
                ),
                InkWell(
                  onTap: () => _showOptionDialog(configProvider, targetProvider, context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: SvgPicture.asset('assets/icons/menu.svg', height: 5.0, width: 5.0),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
              child: LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: 230,
                lineHeight: 7.0,
                percent: targetProvider.getCurrentPercentage(target.startTimestamp ?? 0, target.endTimestamp ?? 0),
                progressColor: targetProvider.isTargetPassed(target) ? Colors.grey : Color.fromRGBO(102, 51, 204, 1),
                leading: Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Text(
                    '${targetProvider.getStartDate(target.startTimestamp ?? 0)}',
                    style: TextStyle(color: targetProvider.isTargetPassed(target) ? Colors.grey : Color.fromRGBO(102, 51, 204, 1)),
                  ),
                ),
                trailing: Container(
                    margin: EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Text('${targetProvider.getEndDate(target.endTimestamp ?? 0)}', style: TextStyle(color: targetProvider.isTargetPassed(target) ? Colors.grey : Color.fromRGBO(102, 51, 204, 1)))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
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
                          '${deleteTargetMessage[configProvider.activeLanguage()]}',
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
                              onPressed: () {
                                Navigator.pop(context);

                                targetProvider.deleteTarget(target.id ?? -1).then((value) {
                                  switch (value) {
                                    case SUCCESS:
                                      {
                                        showSnackBar('${targetDeleteSuccess[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);
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
                              },
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

  Future<void> _showOptionDialog(ConfigProvider configProvider, TargetProvider mainScreenProvider, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTargetScreen(
                                      target: target,
                                    )));
                      },
                      child: Text('${editTarget[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16.0)),
                    )),
                Divider(),
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                        onPressed: () async {
                          await _showDeleteConfirmDialog(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '${deleteTarget[configProvider.activeLanguage()]}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ))),
              ],
            ),
          );
        });
  }
}
