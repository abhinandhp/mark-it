import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/pages/alluserspage.dart';
import 'package:mark_it/pages/friendreqpage.dart';
import 'package:mark_it/pages/friendspage.dart';
import 'package:mark_it/pages/homepage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> screens() {
    return [
      const HomePage(),
      const FriendsPage(),
      const UsersPage(),
      const FriendReqPage(),
    ];
  }

  List<PersistentBottomNavBarItem> navbaritems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(LineIcons.home),
        title: 'Home',
        textStyle: GoogleFonts.outfit(
            color: pricol,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1),
        activeColorPrimary: Colors.white,
        activeColorSecondary: pricol,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_2_fill),
        title: 'Friends',
        textStyle: GoogleFonts.outfit(
            color: pricol,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1),
        activeColorPrimary: Colors.white,
        activeColorSecondary: pricol,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_3_fill),
        title: 'Users',
        textStyle: GoogleFonts.outfit(
            color: pricol,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1),
        activeColorPrimary: Colors.white,
        activeColorSecondary: pricol,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell_fill),
        title: 'Notifications',
        textStyle: GoogleFonts.outfit(
            color: pricol,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 1),
        activeColorPrimary: Colors.white,
        activeColorSecondary: pricol,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcol,
      body: PersistentTabView(
        context,
        screens: screens(),
        items: navbaritems(),
        navBarStyle: NavBarStyle.style7,
        resizeToAvoidBottomInset: true,
        navBarHeight: 65,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: NavBarDecoration(
            colorBehindNavBar: bgcol, borderRadius: BorderRadius.circular(29)),
        handleAndroidBackButtonPress: true,
        backgroundColor: pricol,
        stateManagement: true,
      ),
    );
  }
}
