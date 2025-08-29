import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:st_01/controller/post_controller.dart';
import 'package:st_01/controller/user.dart';
import 'homePage.dart';
import 'profileScreen.dart';
import 'settingScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  final UserController userController = Get.put(UserController());

  List<Widget> _buildScreens() {
    return [
      Homepage(),
      Profilescreen(),
      Settingscreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat_bubble_outline),
        title: "Messages",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.menu),
        title: "Profile",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        stateManagement: true, // Keep state alive
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle: NavBarStyle.style1,
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.zero,
          colorBehindNavBar: Colors.white,
        ),
      ),
    );
  }
}
