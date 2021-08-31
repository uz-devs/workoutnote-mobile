import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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


      print("device pixel  ratio");
    print(MediaQuery.of(context).devicePixelRatio);
    Color backGroundColor;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var screens = [
      _buildHomeScreen(height, width),
      _buildCalendarScreen(height),
      _builCalculateScreen(height),
      _buildSettingsScreen(height),
    ];

    if (_selectedIndex == 0 || _selectedIndex == 2 || _selectedIndex == 1)
      backGroundColor = Color.fromRGBO(231, 223, 247, 1);
    else
      backGroundColor = Color.fromRGBO(255, 255, 255, 1);

    return Scaffold(
      backgroundColor: backGroundColor,
      resizeToAvoidBottomInset: false,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: _selectedIndex == 0 ? _buildHomeSelectedWidget() : _buildHomeBottomIcon(), label: "Home"),
          BottomNavigationBarItem(icon: _selectedIndex == 1 ? _buildCalendarBottomIconSelected() : _buildCalendarBottomIcon(), label: "Calendar"),
          BottomNavigationBarItem(icon: _selectedIndex == 2 ? _buildCalculationSelectedWidget() : _buildCalculationWidget(), label: "Calculation"),
          BottomNavigationBarItem(
              icon: _selectedIndex == 3?_buildBodyIconSelected():_buildBodyIcon(),
              label: "Settings"),
        ],
        onTap: _onItemSelected,
        selectedItemColor: Color.fromRGBO(102, 51, 204, 1),
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
      ),
    );
  }

  Widget _buildHomeScreen(double height, double width) {
    return HomeScreen(height, width);
  }

  Widget _buildCalendarScreen(double height) {
    return CalendarScreen(height);
  }

  Widget _buildSettingsScreen(double height) {
    return SeetingsScreen(height);
  }

  Widget _builCalculateScreen(double height) {
    return CalculateScreen();
  }

  Widget _buildCalendarBottomIconSelected() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/calendar_icon.svg",
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
        SvgPicture.asset(
          "assets/icons/calendar_icon1.svg",
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
      ],
    );
  }

  Widget _buildCalendarBottomIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/calendar_icon.svg",
        ),
        SvgPicture.asset(
          "assets/icons/calendar_icon1.svg",
        ),
      ],
    );
  }

  Widget _buildHomeBottomIcon() {
    return SvgPicture.asset("assets/icons/home.svg");
  }

  Widget _buildHomeSelectedWidget() {
    return SvgPicture.asset(
      "assets/icons/home.svg",
      color: Color.fromRGBO(102, 51, 204, 1),
    );
  }

  Widget _buildCalculationWidget() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.0),
          child: SvgPicture.asset(
            "assets/icons/honor_icon2.svg",
          ),
        ),
        SvgPicture.asset(
          "assets/icons/honor_icon1.svg",
        ),
      ],
    );
  }

  Widget _buildCalculationSelectedWidget() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.0),
          child: SvgPicture.asset(
            "assets/icons/honor_icon2.svg",
            color: Color.fromRGBO(102, 51, 204, 1),
          ),
        ),
        SvgPicture.asset(
          "assets/icons/honor_icon1.svg",
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
      ],
    );
  }

  Widget _buildBodyIcon() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/body_icon1.svg",
        ),
        SvgPicture.asset(
          "assets/icons/body_icon2.svg",
        ),
      ],
    );
  }

  Widget _buildBodyIconSelected() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/body_icon1.svg",
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
        SvgPicture.asset(
          "assets/icons/body_icon2.svg",
          color: Color.fromRGBO(102, 51, 204, 1),

        ),
      ],
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
