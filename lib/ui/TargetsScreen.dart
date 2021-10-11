import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/TargetProvider.dart';
import 'package:workoutnote/ui/widgets/TargetRegisterWidget.dart';
import 'package:workoutnote/ui/widgets/TargetWidget.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class TargetsScreen extends StatefulWidget {
  TargetsScreen({Key? key}) : super(key: key);

  @override
  _TargetsScreenState createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  var targetProvider = TargetProvider();
  var configProvider = ConfigProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    targetProvider = Provider.of<TargetProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
                itemCount: targetProvider.allTargets.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
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
                              '${targetList[configProvider.activeLanguage()]}',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          )))
                        ],
                      ),
                    );
                  }
                  if (index == 1) {
                    return TargetRegisterWidget();
                  } else {
                    index = index - 2;
                    return TargetWidget(target: targetProvider.allTargets[index]);
                  }
                })));
  }
}
