import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/screens/vendor/edit_view_product.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';

class UnpublishedProduct extends StatefulWidget {
  const UnpublishedProduct({Key? key}) : super(key: key);

  @override
  State<UnpublishedProduct> createState() => _UnpublishedProductState();
}

class _UnpublishedProductState extends State<UnpublishedProduct> {
  MyVendorServices _services = MyVendorServices();
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
    return Container(
      child: StreamBuilder(
        stream: _services.getUnPublishedProductByVendor(id: id),
        builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text('Something went wrong...')
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 100,
                headingRowColor: MaterialStateProperty.all(grey),
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('Product'))),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Info')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _productDetails(snapshot.data, context) as List<DataRow>,
              )
            ),
          );
        },
      ),
    );
  }
  List<DataRow>? _productDetails(QuerySnapshot? snapshot, context)  {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document){
      return DataRow(
          cells: [
            DataCell(
              Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Text(
                          'Name : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 15
                          )
                         ,),
                        Expanded(
                          child: Text(
                              document.get('productName'),
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        )
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'SKU : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          )
                          ,),
                        Text(
                          document.get('sku'),
                          style: TextStyle(
                              fontSize: 12
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
            DataCell(
              Container(child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Image.network(document.get('productImage'), width: 60,),
                  ],
                ),
              ))
            ),
            DataCell(
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditViewProduct(productId: document.get('productId')))
                    );
                  },
                  icon: Icon(Icons.info_outline)
                )
            ),
            DataCell(
                popUpButton(document, context: context)
            )
          ]
      );
    }).toList();
    return newList;
  }

  Widget popUpButton(DocumentSnapshot document, {required BuildContext context}){
    MyVendorServices _services = MyVendorServices();

    return PopupMenuButton<String>(
      onSelected: (String value) {
        if(value == 'publish'){
          _services.publishedProduct(
            id: document.get('productId')
          );
          print(document.get('productId'));
        }
        if(value =='delete') {
          _services.deleteProduct(
            id: document.get('productId')
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'publish',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Publish'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Delete Product'),
          ),
        )
      ],
    );
  }
}
