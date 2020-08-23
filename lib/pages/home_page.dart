import 'package:doobeedoo/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:doobeedoo/utils/hex_color.dart';
import 'fav_radios_page.dart';
import 'radio_page.dart';
import 'info_page.dart';
//import 'update_page.dart';
import 'package:package_info/package_info.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _childern = [
    new RadioPage(isFavouriteOnly: false),
    FavRadiosPage(),
    infoRadiosPage(),
    SettingsPage(),
    //UpdatePage(),

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        body: _childern[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: HexColor("#7cc0bf"),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: HexColor("#ffffff"),
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          items: [
            _bottomNavItem(Icons.play_arrow, "Luister"),
            _bottomNavItem(Icons.favorite, "Favoriet"),
            _bottomNavItem(Icons.info, "Over"),
            _bottomNavItem(Icons.settings, "Instellingen"),
           // _bottomNavItem(Icons.update,"Update")
          ],
          onTap: onTabTapped,
        ),
      ),
    );
  }

  _bottomNavItem(IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: new Icon(
        icon,
        color: HexColor("#252626"),
      ),
      activeIcon: new Icon(
        icon,
        color: HexColor("#ffffff"),
      ),
      title: new Text(
        title,
        style: TextStyle(
          color: HexColor("#ffffff"),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    // Error : setState method called after dispose()?
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
  }
}
