import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MyVendorServices{

  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference vendorbanner = FirebaseFirestore.instance.collection('vendorbanner');

  Future<DocumentSnapshot> getProductDetails(id) async{
    return products.doc(id).get();
  }

  getOwnVendor(id){
    return FirebaseFirestore.instance.collection('vendors')
    .doc(id).get();
  }

  getUnPublishedProductByVendor({id}){
    return products.where('published', isEqualTo: false)
        .where('seller.sellerUid', isEqualTo: id)
        .snapshots();
  }

  getPublishedProductByVendor({id}){
    return products.where('published', isEqualTo: true)
        .where('seller.sellerUid', isEqualTo: id)
        .snapshots();
  }

  Future<void> publishedProduct({id}){
    return products.doc(id).update({
      'published' : true
    });
  }

  Future<void> unPublishedProduct({id}){
    return products.doc(id).update({
      'published' : false
    });
  }
  Future<void> deleteProduct({id}){
    return products.doc(id).delete();
  }

  Future<void> saveBanner({url, id}){
    return vendorbanner.add({
      'imageUrl' : url,
      'vendorId' : id
    });
  }

  getBannerById({id}){
    return vendorbanner.where('vendorId', isEqualTo: id)
        .snapshots();
  }

  Future<void> deleteBanner({id}) {
    return vendorbanner.doc(id).delete();
  }
  

}