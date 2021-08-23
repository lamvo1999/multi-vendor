import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/auth_vendor_provider.dart';
import 'package:provider/provider.dart';

class VendorPicCard extends StatefulWidget {
  const VendorPicCard({Key? key}) : super(key: key);

  @override
  _VendorPicCardState createState() => _VendorPicCardState();
}

class _VendorPicCardState extends State<VendorPicCard> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthVendorProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          _authData.getImage().then((image){
            if(mounted){
              setState(() {
                _image = image;
              });
            }
            if(image!= null){
              _authData.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Card(
              child:_image == null
              ? Center(
                  child: Text(
                      'Add Vendor Image',
                    style:TextStyle(color: grey),
                  ),
              ) : Image.file(_image!, fit: BoxFit.fill,),
            ),
          ),
        ),
      ),
    );
  }
}
