import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/TargetProvider.dart';
import 'package:workoutnote/data/models/TargetModel.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import '../TargetsScreen.dart';

class TargetWidget extends StatelessWidget {
  final Target target;
  var configProvider = ConfigProvider();

  TargetWidget({Key? key, required this.target}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var targetProvider = Provider.of<TargetProvider>(context);
    configProvider = Provider.of<ConfigProvider>(context);
    return Container(
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TargetsScreen()),
        ),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
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
                    margin: EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                    width: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: !targetProvider.isTargetPassed(target)
                          ? Text(
                              'D-${targetProvider.getNthDate(target.endTimestamp ?? 0)}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                             target.achieved? '${achieved[configProvider.activeLanguage()]}':'${notAchieved[configProvider.activeLanguage()]}',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                      color: targetProvider.isTargetPassed(target) ? Colors.grey : Color.fromRGBO(102, 51, 204, 1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                    child: GestureDetector(
                        onTap: () {
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
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  width: 250,
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
      ),
    );
  }
}
