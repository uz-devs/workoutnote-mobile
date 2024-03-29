import 'package:intl/date_symbol_data_local.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:workoutnote/ui/LanguageSetScreen.dart';
import 'package:workoutnote/ui/LoginScreen.dart';
import 'package:workoutnote/ui/NavigationController.dart';
import 'package:workoutnote/ui/VerificationScreen.dart';
import 'package:provider/single_child_widget.dart';
import 'package:workoutnote/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'business_logic/ConfigProvider.dart';
import 'business_logic/CreateWorkoutProvider.dart';
import 'business_logic/EditWorkoutProvider.dart';
import 'business_logic/ExerciseDialogProvider.dart';
import 'business_logic/TargetProvider.dart';
import 'business_logic/WorkoutListProvider.dart';

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
    ChangeNotifierProvider(
      create: (_) => TargetProvider(),
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
