import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:Dvciancheck/screens/dashboard/ListScreen/ListScreen.dart';
import 'package:Dvciancheck/screens/dashboard/ScannerScreen/ScannerScreen.dart';

import 'ProfileScreen/ProfileScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

int _page = 0;
GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      ProfileScreen(),
      ScannerScreen(),
      ListScreen(),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.lightBlueAccent.shade100,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(Icons.person_outline_outlined, size: 30),
            Icon(Icons.qr_code_outlined, size: 30),
            Icon(Icons.list_alt_outlined, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: Container(
            color: Colors.lightBlueAccent.shade200,
            child: Center(
              child: _pages[_page],
            )));
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page Two',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page Three',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }
}
