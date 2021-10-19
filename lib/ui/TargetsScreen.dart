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
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color.fromRGBO(102, 51, 204, 1)), onPressed: () => Navigator.of(context).pop()), backgroundColor: Colors.white, title: Text('${targetList[configProvider.activeLanguage()]}')),
      body: Container(
        child: ListView.builder(
            itemCount: targetProvider.allTargets.length + 1,
            itemBuilder: (context, index) {
              if (index == 0)
                return TargetRegisterWidget();
              else
                return TargetWidget(target: targetProvider.allTargets[index - 1]);
            }),
      ),
    );
  }
}
