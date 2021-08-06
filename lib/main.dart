import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/utils/utils.dart';


import 'business logic/calendar provider.dart';
import 'business logic/config provider.dart';
import 'business logic/user management  provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();

  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => UserManagement(),),
    ChangeNotifierProvider(create: (_) => MainScreenProvider(),),
    ChangeNotifierProvider(create: (_) => ConfigProvider(),),
    ChangeNotifierProvider(create: (_) => CalendarProvider(),),

  ];
  runApp(MultiProvider(providers: providers, child: MyApp(),));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
     home: userPreferences!.getString("sessionKey")==null?AuthScreen():NavController(),

    );
  }
}


