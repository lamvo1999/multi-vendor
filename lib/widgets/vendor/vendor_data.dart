import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_dashboard_screen.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OwnVendorWidget extends StatefulWidget {
  const OwnVendorWidget({Key? key}) : super(key: key);

  @override
  _OwnVendorWidgetState createState() => _OwnVendorWidgetState();
}

class _OwnVendorWidgetState extends State<OwnVendorWidget> {
  MyVendorServices _services = MyVendorServices();
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductVendorProvider>(context);
    return FutureBuilder(
      future: _services.getOwnVendor(user.uid),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        var doc = snapshot.data;
        if(doc != null){
          return Container(
            padding: EdgeInsets.only(top: 70,),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.network(
                        doc['imageUrl'],
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vendor Name : ",
                        style: TextStyle(
                            color: grey,
                            fontSize: 16
                        ),
                      ),
                      Text(
                        doc['vendorName'],
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            fontSize: 24
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Continue to the dashboard to manage your shop',
                  style: TextStyle(
                      color: grey,
                      fontSize: 12
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: (){
                            _provider.getVendorName( doc['vendorName']);
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: VENDOR_DASHBOARD),
                              screen: VendorDashboardScreen(),
                              withNavBar: false,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Text(
                            "Vendor Dashboard",
                            style: TextStyle(
                                color: white
                            ),
                          ),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: primary
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
