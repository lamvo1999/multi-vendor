import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:multi_vendor_app/widgets/image_slider.dart';
import 'package:multi_vendor_app/widgets/my_appbar.dart';
import 'package:multi_vendor_app/widgets/near_by_vendor.dart';
import 'package:multi_vendor_app/widgets/top_pic_vendor.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MyAppBar()
          ];
        },
        body: ListView(
          children: [
            ImageSlider(),
            TopRatingVendor(),
            NearByVendors(),
            desAuthor(),
          ],
        ),
      )
    );
  }
  Widget desAuthor() => Padding(
      padding: EdgeInsets.only(top: 30),
      child: Container(
          child: Column(
            children: [
              Center(
                child: Text(
                    "**That\s all folks**",
                    style: TextStyle(
                        color: grey
                    )
                ),
              ),
              Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/city.png'),
                    Positioned(
                        right: 10.0,
                        top: 80,
                        child: Container(
                            width: 100,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Made by :',
                                    style: TextStyle(
                                        color: black
                                    ),
                                  ),
                                  Text(
                                    'LamVo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Anton',
                                        letterSpacing: 2,
                                        color: primary
                                    ),
                                  )
                                ]
                            )
                        )
                    ),
                  ]
              ),
            ],
          )
      )
  );
}
