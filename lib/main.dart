
import 'package:intl/date_symbol_data_local.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/providers/edit%20workout%20%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:workoutnote/ui/language%20set%20screen.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/ui/login%20screen.dart';
import 'package:provider/single_child_widget.dart';
import 'package:workoutnote/ui/verification%20screen.dart';
import 'package:workoutnote/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();
  await initializeDateFormatting('ko_KR', null);

  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => MainScreenProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ConfigProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ExercisesDialogProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CreateWorkoutProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => EditWorkoutProvider(),
    ),
  ];
  runApp(MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget screen;


    if(userPreferences!.getString('sessionKey') == null){
      if(userPreferences!.getBool('signUpDone')??false) screen  = VerificationScreen();
      else screen = LoginScreen();
    }
    else {
      if(userPreferences!.getBool('langSetDone')??false) screen = NavController();
      else screen = LanguageSetScreen();
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workoutnote',
        theme: ThemeData(
          fontFamily: 'NotoSansKR',
          focusColor: Color.fromRGBO(102, 51, 204, 1),
        ),
        home: SplashScreenView(
          navigateRoute:screen,
          duration: 3000,
          imageSize: 100,
          imageSrc: 'assets/images/splash_screen.png',
          backgroundColor: Color.fromRGBO(102, 51, 204, 1),
        ));
  }
}
