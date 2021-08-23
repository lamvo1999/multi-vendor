import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/widgets/vendor/published_product.dart';
import 'package:multi_vendor_app/widgets/vendor/unpublished_product.dart';

class VendorProductScreen extends StatefulWidget {
  const VendorProductScreen({Key? key}) : super(key: key);

  @override
  _VendorProductScreenState createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends State<VendorProductScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text('Products'),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: black,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    CupertinoButton(
                      color: primary,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: white,
                            ),
                            Text(
                              "Add New",
                              style: TextStyle(
                                color: white
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, ADD_NEW_PRODUCT);
                        }
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: primary ,
              labelColor: primary,
              unselectedLabelColor: grey,
              tabs: [
                Tab(text: 'PUBLISHED',),
                Tab(text: 'UN PUBLISHED')
              ],
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: [
                    PublisedProduct(),
                    UnpublishedProduct(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
