import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                 'Delivery address not set',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                 'Please update your Delivery Location to find nearest vendor for you',
                style: TextStyle(
                  color: grey
                ),
              ),
            ),
            CircularProgressIndicator(),
            Container(
              width: 600,
              child: Image.asset(
                'assets/images/city.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: ()async {
                        if(mounted){
                          setState((){
                            _loading = true;
                          });
                        }
                       await _locationProvider.getCurrentPosition();
                       if(_locationProvider.permissionAllowed ==true){
                         Navigator.pushReplacementNamed(context, MAP);
                       }else {
                        Future.delayed(Duration(seconds: 4), (){
                          if(!_locationProvider.permissionAllowed == false) {
                            print('Permission not allowed');
                            if(mounted){
                              setState((){
                                _loading = false;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Vui lòng cho phép để tìm nhà cung cấp gần nhất. '
                                      'Nếu không, bạn không thể sử dụng ứng dụng này.'
                              ),
                            ));
                            Future.delayed(const Duration(milliseconds: 1000), () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            });
                          }
                        });
                       }
                      },
                      child:_loading
                          ? CircularProgressIndicator()
                          : Text(
                           'Set Your Location',
                        style: TextStyle( color: white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
