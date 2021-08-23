import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/screens/favourite_screen.dart';
import 'package:multi_vendor_app/screens/home_screen.dart';
import 'package:multi_vendor_app/screens/my_orders_screen.dart';
import 'package:multi_vendor_app/screens/my_vendor_screen.dart';
import 'package:multi_vendor_app/screens/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        HomeScreen(),
        FavouriteScreen(),
        MyOrderScreen(),
        MyVendorScreen(),
        ProfileScreen()
      ];
    }

    PersistentBottomNavBarItem _buildBottomNavBarItem(IconData iconData, String label) {
      return PersistentBottomNavBarItem(
        icon: Icon(iconData),
        title: (label),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      );
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        _buildBottomNavBarItem(CupertinoIcons.home, "Home"),
        _buildBottomNavBarItem(CupertinoIcons.square_favorites_alt, "My Favourites"),
        _buildBottomNavBarItem(CupertinoIcons.bag, "My Orders"),
        _buildBottomNavBarItem(CupertinoIcons.house_alt, "Own Vendor"),
        _buildBottomNavBarItem(CupertinoIcons.rectangle_stack_person_crop, "My Profile"),
      ];
    }


    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
          border: Border.all(
            color: black
          ),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
