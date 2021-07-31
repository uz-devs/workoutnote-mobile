import 'package:flutter/material.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/utils/utils.dart';

class NavController extends StatefulWidget {
  static String route = "/";

  const NavController();

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deltoid"),
      ),
      body: Center(
        child: Text("Hey Ilyosbek"),
      ),
    );
  }
}
