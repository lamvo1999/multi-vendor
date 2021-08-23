import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthVendorProvider extends ChangeNotifier{
  File? image;
  bool isPicAvail = false;
  String pickError="" ;
  double? vendorLatitude;
  double? vendorLongitude;
  String? vendorAddress;
  String error ="";
  String? placeName;
  bool checkVendor = false;

  Future<void> checkOwnVendor(id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await  firestore.collection('vendors').doc(id).get();
    if(doc.exists){
      this.checkVendor = true;
      notifyListeners();
    }else {
      this.checkVendor = false;
      notifyListeners();
    }
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      this.image = File(pickedFile.path);
      notifyListeners();
    }else {
      this.pickError = "No image selected.";
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  Future getCurrentVendor() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.vendorLatitude = _locationData.latitude;
    this.vendorLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    final _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var _vendorAddress = _addresses.first;
    this.vendorAddress = _vendorAddress.addressLine;
    this.placeName = _vendorAddress.featureName;
    notifyListeners();
    return vendorAddress;
  }

  Future<String?> uploadFile(fileName) async{
    File file = File(this.image!.path);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('uploads/shopProfilePic/${fileName}').putFile(file);
    }on FirebaseException catch(e) {
      print(e.code);
    }
    String downloadUrl = await _storage.ref('uploads/shopProfilePic/${fileName}').getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveVendorDataToDB(String url, String vendorName,String email ,String mobile, String dialog) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set({
      'uid': user.uid,
      'vendorName': vendorName,
      'totalRating' : 0,
      'shopOpen': "",
      'rating' : 0,
      "mobile": mobile,
      'location' : {
        'address' : this.vendorAddress,
        'latitude' : this.vendorLatitude,
        'longitude': this.vendorLongitude,
      },
      'isTopRating': false,
      'imageUrl': url,
      'email': email,
      'dialog': dialog,
      'accVerified': false,
    });
    return null;
  }

}