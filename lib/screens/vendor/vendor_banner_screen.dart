import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';
import 'package:multi_vendor_app/widgets/vendor/banner_card.dart';
import 'package:provider/provider.dart';

class VendorBannerScreen extends StatefulWidget {
  const VendorBannerScreen({Key? key}) : super(key: key);

  @override
  _VendorBannerScreenState createState() => _VendorBannerScreenState();
}

class _VendorBannerScreenState extends State<VendorBannerScreen> {

  MyVendorServices _services = MyVendorServices();
  bool _visible = false;
  File? _image ;
  var _imagePathText = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    if(mounted){
      setState((){
        id = user!.uid;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductVendorProvider>(context);
    return Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            BannerCard(),
            Divider(thickness: 3,),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: Text(
                  'ADD NEW BANNER',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    showImage(),
                    TextFormField(
                      enabled: false,
                      controller: _imagePathText,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 20),
                    addNewBanner(),
                    groupButtonWidget(provider: provider),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget addNewBanner() => Visibility(
    visible: _visible ? false:true,
    child: Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              if(mounted){
                setState((){
                  _visible = true;
                });
              }
            },
            child: Text(
              'Add New Banner',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: primary,
            ),
          ),
        ),
      ],
    ),
  );

  Widget showImage() =>  SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: grey,
        child: _image != null
            ? Image.file(_image as File,
          fit: BoxFit.fill,
        )
            : Center(
            child: Text('No Image Selected')
        ),
      )
  );

  Widget groupButtonWidget({provider}) => Visibility(
    visible: _visible,
    child: Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    provider.getBannerImage().then((image) {
                      if(image!= null){
                        if(mounted){
                          setState((){
                            _image = image;
                            _imagePathText.text = image.path;
                          });
                        }
                      }
                    });
                  },
                  child: Text(
                    'Upload Banner',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AbsorbPointer(
                  absorbing: _image!=null ? false : true,
                  child: TextButton(
                    onPressed: () {
                      EasyLoading.show();
                      provider.uploadBannerImage(_image).then((downUrl){
                        if(downUrl!= null){
                          _services.saveBanner(
                              url: downUrl,
                              id: id
                          );
                          EasyLoading.dismiss();
                          provider.alertDialog(
                              context: context,
                              title: 'Banner Upload',
                              content: 'Banner Image Upload Successfully...'
                          );
                        }else {
                          EasyLoading.dismiss();
                          provider.alertDialog(
                              context: context,
                              title: 'Banner Upload',
                              content: 'Banner Upload Failed!'
                          );
                        }
                      });
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: white
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:_image!=null ? primary: blueAc,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if(mounted){
                      setState((){
                        _visible = false;
                        _imagePathText.clear();
                        _image = null;
                      });
                    }
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

