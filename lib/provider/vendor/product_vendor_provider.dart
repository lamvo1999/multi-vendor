import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductVendorProvider with ChangeNotifier{
  String? selectedCategory ;
  String? selectedSubCategory;
  String? categoryImage;
  String? pickError;
  File? image;
  String? vendorName;
  String? productUrl;

  CollectionReference products = FirebaseFirestore.instance.collection('products');

  resetData() async {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.pickError = null;
    this.image = null;
    this.vendorName = null;
    this.productUrl = null;
    notifyListeners();
  }

  selectCategory(mainCategory, categoryImage){
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected){
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getVendorName(vendorName){
    this.vendorName = vendorName;
    notifyListeners();
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
  Future<File?> getBannerImage() async {
    File? bannerImage;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      bannerImage = File(pickedFile.path);
      notifyListeners();
    }else {
      print('No image selected');
      notifyListeners();
    }
    return bannerImage;
  }

  Future<String?> uploadProductImage(fileName, productName) async{
    File file = File(this.image!.path);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('productImage/${this.vendorName}/$productName$timeStamp').putFile(file);
    }on FirebaseException catch(e) {
      print(e.code);
    }
    String downloadUrl = await _storage.ref('productImage/${this.vendorName}/$productName$timeStamp').getDownloadURL();
    this.productUrl = downloadUrl;
    notifyListeners();
    return downloadUrl;
  }

  Future<String?> uploadBannerImage(filePath) async{
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('bannerImage/${this.vendorName}/$timeStamp').putFile(filePath);
    }on FirebaseException catch(e) {
      print(e.code);
    }
    String downloadUrl = await _storage.ref('bannerImage/${this.vendorName}/$timeStamp').getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateProduct({
    context,
    productName,
    description,
    price,
    comparedPrice,
    collection,
    sku,
    weight,
    stockQty,
    lowStockQty,
    productId,
    category,
    subCategory,
    image,
    categoryImage,
    }) async{
    CollectionReference _product = FirebaseFirestore.instance.collection('products');
    try {
      await _product.doc(productId).set({
        'productName' : productName,
        'description' : description,
        'price' : price,
        'comparedPrice' : comparedPrice,
        'collection' : collection,
        'sku' : sku,
        'category' : {
          'mainCategory' : category,
          'subCategory' : subCategory,
          'categoryImage' : this.categoryImage == null ? categoryImage : this.categoryImage
        },
        'weight' : weight,
        'stockQty' : stockQty,
        'lowStockQty' : lowStockQty,
        'productImage': this.productUrl == null ? image : this.productUrl
      });
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product Details saved successfully',
      );
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: e.toString(),
      );
    }
    return null;
  }

  Future<void> saveProductDataToDb({
    context,
    productName,
    description,
    price,
    comparedPrice,
    collection,
    sku,
    weight,
    stockQty,
    lowStockQty,
  }) async{
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _product = FirebaseFirestore.instance.collection('products');
    try {
      await _product.doc(timeStamp.toString()).set({
        'seller' : {
          'vendorName' : this.vendorName,
          'sellerUid' : user!.uid,
        },
        'productName' : productName,
        'description' : description,
        'price' : price.toString,
        'comparedPrice' : comparedPrice,
        'collection' : collection,
        'sku' : sku,
        'category' : {
          'mainCategory' : this.selectedCategory,
          'subCategory' : this.selectedSubCategory,
          'categoryImage' : this.categoryImage
        },
        'weight' : weight,
        'stockQty' : stockQty,
        'lowStockQty' : lowStockQty,
        'published' : false,
        'productId' : timeStamp.toString(),
        'productImage': this.productUrl
      });
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product Details saved successfully',
      );
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: e.toString(),
      );
    }
    return null;
  }

  alertDialog({context, title, content}){
    showCupertinoDialog(context: context, builder:(BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }

}