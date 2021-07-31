import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/ui/auth%20screen%20.dart';
import 'package:workoutnote/ui/calculate%20screen.dart';
import 'package:workoutnote/ui/calendar%20screen.dart';
import 'package:workoutnote/ui/home%20screen.dart';
import 'package:workoutnote/ui/settings%20%20screen.dart';
import 'package:workoutnote/ui/widgets/work%20out%20%20note%20card.dart';
import 'package:workoutnote/utils/utils.dart';

class NavController extends StatefulWidget {
  static String route = "/";

  const NavController();

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var screens = [_buildHomeScreen(height), _buildCalendarScreen(height), _buildSettingsScreen(height), _buildSettingsScreen(height)];
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calculation"),

        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),

      ],
        onTap: _onItemSelected,
        selectedItemColor: Colors.deepPurpleAccent,
        currentIndex: _selectedIndex,

        unselectedItemColor: Colors.black38,
      ),
    );
  }

  Widget _buildHomeScreen(double height) {
    return HomeScreen(height);
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
