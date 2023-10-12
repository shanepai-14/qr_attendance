import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance/screens/dashboard/GuardDashboard/GuardAttendanceScreen/GuardAttendanceScreen.dart';
import 'package:qr_attendance/screens/dashboard/GuardDashboard/GuardScannerScreen/GuardScannerScreen.dart';
import 'package:qr_attendance/screens/dashboard/ListScreen/ListScreen.dart';
import 'package:qr_attendance/screens/dashboard/ScannerScreen/ScannerScreen.dart';

import '../ProfileScreen/ProfileScreen.dart';

class GuardDashboardScreen extends StatefulWidget {
  const GuardDashboardScreen({Key? key}) : super(key: key);

  @override
  State<GuardDashboardScreen> createState() => _DashboardState();
}

int _page = 0;
GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

class _DashboardState extends State<GuardDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      ProfileScreen(),
      GuardScannerScreen(),
      GuardAttendanceScreen(),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.1),
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
