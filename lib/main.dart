import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/edit%20workout%20%20provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();

  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => MainScreenProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ConfigProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => SearchDialogProvider(),
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionColor: Colors.white ,
          fontFamily: 'NotoSansKR',
          focusColor: Color.fromRGBO(102, 51, 204, 1),
        ),
        home: SplashScreenView(
          navigateRoute: userPreferences!.getString("sessionKey") == null ? AuthScreen() : NavController(),
          duration: 3000,
          imageSize: 100,
          imageSrc: "assets/images/splash_screen.png",
          backgroundColor: Color.fromRGBO(102, 51, 204, 1),
        ));
  }
}
