
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class VendorServices{

  getVendorByTopRating(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopRating', isEqualTo: true)
        .orderBy('vendorName')
        .snapshots();
  }

  getVerifyedVendors(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('vendorName')
        .snapshots();
  }
  getVerifyedVendorsPagination(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('vendorName');
  }

  
}