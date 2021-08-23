import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:multi_vendor_app/screens/map_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  String _location = '';
  String _address = '';

  @override
  void initState() {
    // TODO: implement initState
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    String? address = prefs.getString('address');
    setState(() {
      _location = location!;
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      title: GestureDetector(
        onTap: () {
          locationData.getCurrentPosition();
          if(locationData.permissionAllowed==true){
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: MAP),
              screen: MapScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }else {
            print('Permission not allowed');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    _location ==null ? "Địa chỉ chưa thiết lập"
                        :_location,
                    style: TextStyle(
                        color: white,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: white,
                  size: 15,
                ),
              ],
            ),
            Flexible(
                child: Text(
                  _address == null
                      ?'Press here to set Delevery Location'
                      : _address,
                  style: TextStyle(
                    color: white,
                    fontSize: 12
                  ),
                )
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: grey,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: white
            ),
          ),
        ),
      ),
    );
  }
}
