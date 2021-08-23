import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/screens/vendor/register_vendor_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NotDataVendorWidget extends StatefulWidget {
  const NotDataVendorWidget({Key? key}) : super(key: key);

  @override
  _NotDataVendorWidgetState createState() => _NotDataVendorWidgetState();
}

class _NotDataVendorWidgetState extends State<NotDataVendorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: <Widget>[
         Container(
             child: Padding(
               padding: const EdgeInsets.only(top: 50, bottom: 20),
               child: Image.asset(
                 'assets/images/notvendor.jpg',
                 fit: BoxFit.fill,
               ),
             )
         ),
          Text(
            'Are you a Vendor?',
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Lato'
            ),
          ),
          Text(
            'If you a Vendor. Please register.',
            style: TextStyle(
              color: grey,
              fontSize: 12
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: REGISTER_VENDOR),
                        screen: RegisterVendorScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Text(
                      "Register As A Vendor",
                      style: TextStyle(
                        color: white
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: primary
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'If you not a Vendor. Please ignore this page.',
            style: TextStyle(
                color: grey,
                fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}
