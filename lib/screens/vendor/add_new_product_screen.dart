import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/widgets/vendor/category_list.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _lowStockQtyTextController = TextEditingController();
  var _stockQtyTextController = TextEditingController();
  File? _image;
  bool _visible = false;
  bool _track = false;

  String? productName;
  String? description;
  int? price;
  int? compared;
  String? sku;
  String? weight;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductVendorProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
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
                          child: Text('Product / Add'),
                        ),
                      ),
                      _saveDataProductButton(
                         onPress: () {
                           if(_formKey.currentState!.validate()){
                             if(_categoryTextController.text.isNotEmpty){
                               if(_subCategoryTextController.text.isNotEmpty){
                                 if(_image!=null){
                                   EasyLoading.show(status: 'Saving...');
                                   _provider.uploadProductImage(_image!.path, productName).then((url) {
                                     if(url!= null){
                                       EasyLoading.dismiss();
                                       _provider.saveProductDataToDb(
                                           context: context,
                                           comparedPrice: _comparedPriceTextController.text,
                                           collection: dropdownValue,
                                           description: description,
                                           lowStockQty: int.parse(_lowStockQtyTextController.text),
                                           price: price,
                                           sku: sku,
                                           stockQty: int.parse(_stockQtyTextController.text),
                                           weight: weight,
                                           productName: productName
                                       );
                                       if(mounted){
                                         setState((){
                                           _formKey.currentState!.reset();
                                           _comparedPriceTextController.clear();
                                           dropdownValue = null;
                                           _subCategoryTextController.clear();
                                           _categoryTextController.clear();
                                           _track = false;
                                           _image = null;
                                           _visible = false;
                                       });
                                       }

                                     }else {
                                       _provider.alertDialog(
                                           context: context,
                                           title: 'Image Upload',
                                           content: 'Failed to upload product image'
                                       );
                                     }
                                   });
                                 }else {
                                   _provider.alertDialog(
                                       context: context,
                                       title: 'PRODUCT IMAGE',
                                       content: 'Product Image not selected'
                                   );
                                 }
                               }else {
                                 _provider.alertDialog(
                                     context: context,
                                     title: "Sub Category",
                                     content: 'Sub Category not selected'
                                 );
                               }
                             }else {
                               _provider.alertDialog(
                                   context: context,
                                   title: "Main Category",
                                   content: 'Main Category not selected'
                               );
                             }
                           }
                         }
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: primary ,
                  labelColor: primary,
                  unselectedLabelColor: grey,
                  tabs: [
                    Tab(text: 'GENERAL',),
                    Tab(text: 'INVENTORY')
                  ]
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  _inputInforProductWidget(
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "Enter product name";
                                        }
                                        if(mounted){
                                          setState((){
                                            productName = value;
                                          });
                                        }
                                        return null;
                                      },
                                      label: 'Product Name',
                                      type: false
                                  ),
                                  _inputInforProductWidget(
                                    validator: (value) {
                                      if(value!.isEmpty){
                                        return "Enter description";
                                      }
                                      if(mounted){
                                        setState((){
                                          description = value;
                                        });
                                      }
                                      return null;
                                    },
                                      label: 'About Product',
                                      type: false
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        _provider.getImage().then((image){
                                          if(mounted){
                                            setState((){
                                              _image = image;
                                            });
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          child: Center(
                                            child:_image == null
                                              ? Text('Select Image')
                                            : Image.file(_image as File),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _inputInforProductWidget(
                                      validator: (value) {
                                            if(value!.isEmpty){
                                              return "Enter selling price";
                                            }
                                            if(mounted){
                                              setState((){
                                                price = int.parse(value);
                                              });
                                            }
                                            return null;
                                      },
                                      label: 'Price',
                                      type: true
                                  ),
                                  _inputInforProductWidget(
                                      validator: (value) {
                                        if(price! > double.parse(value!)){
                                          return "Compared price shouble be higher than price";
                                        }
                                        if(mounted){
                                          setState((){
                                            compared = int.parse(value);
                                          });
                                        }
                                        return null;
                                      },
                                      label: 'Compared Price',
                                      type: true,
                                    controller: _comparedPriceTextController
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text('Collection'),
                                        SizedBox(width: 10),
                                        DropdownButton<String>(
                                          hint: Text('Select Collection'),
                                          value: dropdownValue,
                                          icon: Icon(Icons.arrow_drop_down),
                                          onChanged: (String? value) {
                                            setState((){
                                              dropdownValue = value;
                                            });
                                          },
                                          items: _collections.map<DropdownMenuItem<String>>((String value){
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child:Text(value)
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _inputInforProductWidget(
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "Enter SKU";
                                        }
                                        if(mounted){
                                          setState((){
                                            sku = value;
                                          });
                                        }
                                        return null;
                                      },
                                      label: 'SKU',
                                      type: false,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Category',
                                          style: TextStyle(
                                            color: grey,
                                            fontSize: 16
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: _inputInforProductWidget(
                                              validator: (value) {
                                                if(value!.isEmpty){
                                                  return 'select category name';
                                                }
                                                return null;
                                              },
                                              label: 'Category',
                                              type: false,
                                              controller: _categoryTextController,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed:() {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return CategoryList();
                                              }
                                            ).whenComplete((){
                                              if(mounted){
                                                setState((){
                                                  _categoryTextController.text= _provider.selectedCategory!;
                                                  _visible = true;
                                                });
                                              }
                                            });
                                          } ,
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Sub Category',
                                            style: TextStyle(
                                              color: grey,
                                              fontSize: 16
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Visibility(
                                              visible: true,
                                              child: _inputInforProductWidget(
                                                validator: (value) {
                                                  if(value!.isEmpty){
                                                    return 'select Sub Category name';
                                                  }
                                                  return null;
                                                },
                                                label: 'SubCategory',
                                                type: false,
                                                controller: _subCategoryTextController,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit_outlined),
                                            onPressed:() {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return SubCategoryList();
                                                  }
                                              ).whenComplete((){
                                                if(mounted){
                                                  setState((){
                                                    _subCategoryTextController.text= _provider.selectedSubCategory!;
                                                  });
                                                }
                                              });
                                            } ,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  _inputInforProductWidget(
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "Enter weight";
                                        }
                                        if(mounted){
                                          setState((){
                                            weight = value;
                                          });
                                        }
                                        return null;
                                      },
                                      label: 'Weight. eg: -Kg, gm, etc',
                                      type: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                              children: [
                                SwitchListTile(
                                    title: Text('Track Inventory'),
                                    activeColor: primary,
                                    subtitle: Text(
                                      'Switch ON to track Inventory',
                                      style: TextStyle(
                                        color: grey,
                                        fontSize: 12
                                      ),
                                    ),
                                    value: _track,
                                    onChanged: (selected){
                                      if(mounted){
                                        setState((){
                                          _track = !_track;
                                        });
                                      }
                                    }
                                ),
                                Visibility(
                                  visible: _track,
                                  child: SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            _inputInforProductWidget(
                                              validator: (value) {},
                                              label: 'Inventory Quantily',
                                              type: true,
                                              controller: _stockQtyTextController,
                                            ),
                                            _inputInforProductWidget(
                                              validator: (value) {},
                                              label: 'Inventory low stock quantily',
                                              type: true,
                                              controller: _lowStockQtyTextController,
                                            ),
                                          ]
                                        )
                                      )
                                    )
                                  ),
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputInforProductWidget({required FormFieldValidator validator, required String label, required bool type, TextEditingController? controller}) => TextFormField(
    validator: validator,
    controller: controller,
    keyboardType: type ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: grey),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: grey
            )
        )
    ),
  );

  Widget _saveDataProductButton({required VoidCallback onPress}) => CupertinoButton(
      color: primary,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.save_outlined,
            color: white,
          ),
          Text(
            "Save",
            style: TextStyle(
                color: white
            ),
          ),
        ],
      ),
      onPressed: onPress,
  );
}
