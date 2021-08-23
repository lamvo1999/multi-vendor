import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_banner_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_home_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_product_screen.dart';
import 'package:multi_vendor_app/widgets/vendor/menu_widget.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({Key? key}) : super(key: key);

  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {

  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  late String title;

  @override
  void initState() {
    title = "Dashboard";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: SliderMenuContainer(
            appBarColor: Colors.white,
            key: _key,
            sliderMenuOpenSize: 200,
            trailing: Row(
              children: [
                IconButton(
                  onPressed: (){},
                  icon: Icon(CupertinoIcons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.bell),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, MAIN, (Route<dynamic> route) => false);
                  },
                  icon: Icon(CupertinoIcons.square_arrow_left),
                )
              ],
            ),
            title: Text(
              "",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            sliderMenu: MenuWidget(
              onItemClick: (title) {
                _key.currentState!.closeDrawer();
                setState(() {
                  this.title = title;
                });
              },
            ),
            sliderMain: drawerScreen(title)),
      ),
    );
  }
  Widget drawerScreen(title){
    if(title == "Home"){
      return VendorHomeScreen();
    }
    if(title == "Product"){
      return VendorProductScreen();
    }
    if(title == "Banner"){
      return VendorBannerScreen();
    }
    return VendorHomeScreen();
  }

}
