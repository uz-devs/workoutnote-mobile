import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workoutnote/business_logic/WorkoutListProvider.dart';


import 'CalculateScreen.dart';
import 'CalendarScreen.dart';
import 'HomeScreen.dart';
import 'SettingsScreen.dart';

class NavController extends StatefulWidget {
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');



  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _selectedIndex = 0;
  var listProvider = MainScreenProvider();
  RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<MainScreenProvider>(context, listen: false );

    Color backGroundColor;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var screens = [
      _buildHomeScreen(height, width),
      _buildCalendarScreen(height),
      _builCalculateScreen(height),
      _buildSettingsScreen(height),
    ];

    if (_selectedIndex == 0 || _selectedIndex == 1)
      backGroundColor = Color.fromRGBO(231, 223, 247, 1);
    else
      backGroundColor = Color.fromRGBO(255, 255, 255, 1);

    return Scaffold(
      backgroundColor: backGroundColor,
     // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SmartRefresher(
          onRefresh: _onRefresh,
          enablePullDown: true,
          header: MaterialClassicHeader(
            color: Color.fromRGBO(102, 51, 204, 1),
          ),
          controller: _refreshController,
          child: screens[_selectedIndex],
        ),
      ),
      // : screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        key:widget.globalKey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: _selectedIndex == 0 ? _buildHomeSelectedWidget() : _buildHomeBottomIcon(), label: 'Home'),
          BottomNavigationBarItem(icon: _selectedIndex == 1 ? _buildCalendarBottomIconSelected() : _buildCalendarBottomIcon(), label: 'Calendar'),
          BottomNavigationBarItem(icon: _selectedIndex == 2 ? _buildCalculationSelectedWidget() : _buildCalculationWidget(), label: 'Calculation'),
          BottomNavigationBarItem(icon: _selectedIndex == 3 ? _buildBodyIconSelected() : _buildBodyIcon(), label: 'Settings'),
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
    return SettingsScreen(height);
  }

  Widget _builCalculateScreen(double height) {
    return CalculateScreen();
  }

  Widget _buildCalendarBottomIconSelected() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/calendar_icon.svg',
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
        SvgPicture.asset(
          'assets/icons/calendar_icon1.svg',
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
          'assets/icons/calendar_icon.svg',
        ),
        SvgPicture.asset(
          'assets/icons/calendar_icon1.svg',
        ),
      ],
    );
  }

  Widget _buildHomeBottomIcon() {
    return SvgPicture.asset('assets/icons/home.svg');
  }

  Widget _buildHomeSelectedWidget() {
    return SvgPicture.asset(
      'assets/icons/home.svg',
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
            'assets/icons/honor_icon2.svg',
          ),
        ),
        SvgPicture.asset(
          'assets/icons/honor_icon1.svg',
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
            'assets/icons/honor_icon2.svg',
            color: Color.fromRGBO(102, 51, 204, 1),
          ),
        ),
        SvgPicture.asset(
          'assets/icons/honor_icon1.svg',
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
      ],
    );
  }

  Widget _buildBodyIcon() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/body_icon1.svg',
        ),
        SvgPicture.asset(
          'assets/icons/body_icon2.svg',
        ),
      ],
    );
  }

  Widget _buildBodyIconSelected() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/body_icon1.svg',
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
        SvgPicture.asset(
          'assets/icons/body_icon2.svg',
          color: Color.fromRGBO(102, 51, 204, 1),
        ),
      ],
    );
  }


  void  _onRefresh() async{



    listProvider.reset();
    await Future.delayed(Duration(milliseconds: 200));
    _refreshController.refreshCompleted();

  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
