import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {

  MyVendorServices services = MyVendorServices();
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
    return StreamBuilder<QuerySnapshot>(
      stream: services.getBannerById(id: id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Image.network(data['imageUrl'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      foregroundColor: white,
                      child: IconButton(
                        onPressed: (){
                          print(document.id);
                          EasyLoading.show();
                          services.deleteBanner(id: document.id);
                          EasyLoading.dismiss();
                        },
                        icon: Icon(CupertinoIcons.delete)
                      ),
                    )
                  )
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
