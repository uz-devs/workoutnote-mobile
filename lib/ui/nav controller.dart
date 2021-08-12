import 'package:flutter/material.dart';
import 'package:workoutnote/ui/calculate%20screen.dart';
import 'package:workoutnote/ui/calendar%20screen.dart';
import 'package:workoutnote/ui/home%20screen.dart';
import 'package:workoutnote/ui/settings%20%20screen.dart';

class NavController extends StatefulWidget {
  static String route = "/";

  const NavController();

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {


    Color backGroundColor;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var screens = [_buildHomeScreen(height, width), _buildCalendarScreen(height),  _builCalculateScreen(height), _buildSettingsScreen(height),];

    if(_selectedIndex == 0  || _selectedIndex == 2)
      backGroundColor =  Color.fromRGBO(231, 223, 247, 1);

    else backGroundColor = Color.fromRGBO(255, 255, 255, 1);

    return Scaffold(
      backgroundColor: backGroundColor,
      resizeToAvoidBottomInset: false,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined,  size: 30,), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today,  size: 30,), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.calculate, size: 30,), label: "Calculation"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30,), label: "Settings"),

      ],
        onTap: _onItemSelected,
        selectedItemColor:  Color.fromRGBO(102, 51, 204, 1),
        currentIndex: _selectedIndex,

        unselectedItemColor: Colors.black38,
      ),
    );
  }

  Widget _buildHomeScreen(double height,  double width) {
    return HomeScreen(height, width);
  }

  Widget _buildCalendarScreen(double height) {
    return CalendarScreen(height);
  }

  Widget _buildSettingsScreen(double height) {
    return SeetingsScreen(height);
  }

  Widget _builCalculateScreen(double height){
    return CalculateScreen();
  }

  void  _onItemSelected(int  index){
    setState(() {
      _selectedIndex = index;
    });
  }
}
