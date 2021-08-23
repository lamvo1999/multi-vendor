import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/services/user_services.dart';
import 'package:multi_vendor_app/services/vendor_services.dart';

class VendorProvider with ChangeNotifier{
  VendorServices _vendorServices = VendorServices();
  UserServices _userService = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  Future<void> getUserLocationData(context) async{
    _userService.getUserById(user!.uid).then((result) {
      if(user!=null) {
        this.userLatitude = result.get('location.latitude');
        this.userLongitude = result.get('location.longitude');
      }else {
        Navigator.pushNamedAndRemoveUntil(context, LOGIN, (Route<dynamic> route) => false);
      }
    });
  }

}