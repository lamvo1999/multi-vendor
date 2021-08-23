import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/style.dart';

class MenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? vendorData;

  @override
  void initState() {
    // TODO: implement initState
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async{
    var result = await FirebaseFirestore.instance.collection('vendors').doc(user?.uid).get();
    if(mounted) {
      setState((){
        vendorData = result as DocumentSnapshot<Object?>?;
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:vendorData!= null
                        ? NetworkImage(vendorData!.get('imageUrl'))
                        :null,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      vendorData!=null
                      ?vendorData!.get('vendorName')
                      : "Loadding ...",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'BalsamiqSans'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            sliderItem('Home', Icons.home),
            sliderItem('Product', CupertinoIcons.rectangle_grid_2x2),
            sliderItem('Banner', CupertinoIcons.photo_on_rectangle),
            sliderItem('Coupons', CupertinoIcons.gift),
            sliderItem('Orders', Icons.list_alt_rounded),
            sliderItem('Reports', Icons.stacked_bar_chart),
            sliderItem('Setting', Icons.settings),
          ],
        ),
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grey,
          )
        )
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(icons, color: black, size: 18,),
              SizedBox(width: 10,),
              Text(
                title,
                style: TextStyle(
                  color: black,
                  fontSize: 12
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      widget.onItemClick!(title);
      print(title);
    });
}