import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  MyVendorServices _services = MyVendorServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductVendorProvider>(context);
    return Dialog(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    'Select Category',
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                      Icons.close,
                    color: white,
                  ),
                ),
              ],
            )
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError) {
                return Center(
                  child: Text('Some thing went wrong'),
                );
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(document.get('image')),
                      ),
                      title: Text(document.get('name')),
                      onTap: () {
                        _provider.selectCategory(
                            document.get('name'),
                            document.get('image'));
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key? key}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  MyVendorServices _services = MyVendorServices();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductVendorProvider>(context);
    return Dialog(
      child: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              color: primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Select Sub Category',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: white,
                    ),
                  ),
                ],
              )
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _services.category.doc(_provider.selectedCategory).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasError) {
                return Center(
                  child: Text('Some thing went wrong'),
                );
              }
              if(snapshot.connectionState == ConnectionState.done){
                var doc = snapshot.data;
                if(doc!=null){
                  return Expanded(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Row(
                                  children: [
                                    Text('Main Category'),
                                    FittedBox (
                                      child: Text(
                                        _provider.selectedCategory!,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ),
                          Divider(thickness: 3,),
                          Container(
                              child: Expanded(
                                child: ListView.builder(
                                  itemBuilder: (BuildContext context, int index){
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                            child: Text('${index +1}'),
                                          ),
                                          title: Text(doc['subCat'][index]['name']),
                                          onTap: (){
                                            _provider.selectSubCategory(doc['subCat'][index]['name']);
                                            Navigator.pop(context);
                                          }
                                      ),
                                    );
                                  },
                                  itemCount: doc['subCat'] == null ? 0 : doc['subCat'].length,
                                ),
                              )
                          )
                        ],
                      )
                  );
                }else {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator()
              );

            },
          ),
        ],
      ),
    );
  }
}

