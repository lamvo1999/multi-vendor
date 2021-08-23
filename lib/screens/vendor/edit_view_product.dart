import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/services/vendor/my_verdor_services.dart';
import 'package:multi_vendor_app/widgets/vendor/category_list.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  String productId;
  EditViewProduct({required this.productId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {

  MyVendorServices _services = MyVendorServices();
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot? doc;
  bool _visible = false;
  bool _editing = false;

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;

  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comPriceText = TextEditingController();
  var _desText = TextEditingController();
  var _categoryText = TextEditingController();
  var _subCategoryText = TextEditingController();
  var _stockText = TextEditingController();
  var _lowStockText = TextEditingController();
  double discount = 0.0;
  String image = "";
  String? categoryImage;
  File? _image;

  @override
  void initState() {
    _services.getProductDetails(widget.productId).then((document){
      if(document.exists){
          setState((){
            doc = document;
            _skuText.text = document.get('sku');
            _productNameText.text = document.get('productName');
            _weightText.text = document.get('weight');
            _priceText.text = document.get('price').toString();
            _comPriceText.text = document.get('comparedPrice').toString();
            _desText.text = document.get('description');
            var difference = int.parse(_priceText.text) - int.parse(_comPriceText.text);
            discount = ((difference/int.parse(_comPriceText.text))*100);
            image = document.get('productImage');
            _categoryText.text = document.get('category.mainCategory');
            _subCategoryText.text = document.get('category.subCategory');
            categoryImage = document.get('category.categoryImage');
            dropdownValue = document.get('collection');
            _stockText.text = document.get('stockQty').toString();
            _lowStockText.text = document.get('lowStockQty').toString();
          });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductVendorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: white
        ),
        actions: [
          buttonWidget(
              ontap: () {
                if(mounted){
                  setState((){
                    _editing = false;
                  });
                }
              },
              title: 'Edit ',
              color: primary,
              textColor: white
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: buttonWidget(
                  ontap: (){
                    Navigator.pop(context);
                  },
                  title: 'Cancel',
                  color: black,
                  textColor: white
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: buttonWidget(
                    ontap: (){
                      if(_formKey.currentState!.validate()){
                        EasyLoading.show(status: 'Saving...');
                        if(_image!=null){
                          provider.uploadProductImage(_image!.path, _productNameText.text)
                              .then((url){
                            if(url!=null){
                              provider.updateProduct(
                                context: context,
                                productName: _productNameText.text,
                                weight: _weightText.text,
                                stockQty: int.parse(_stockText.text),
                                lowStockQty: int.parse(_lowStockText.text),
                                sku: _skuText.text,
                                price: int.parse(_priceText.text),
                                description: _desText.text,
                                collection: dropdownValue,
                                comparedPrice: int.parse(_comPriceText.text),
                                productId: widget.productId,
                                image: image,
                                category: _categoryText.text,
                                subCategory: _subCategoryText.text,
                                categoryImage: categoryImage,
                              );
                              EasyLoading.dismiss();
                            }
                          });
                        }else {
                          provider.updateProduct(
                            context: context,
                            productName: _productNameText.text,
                            weight: _weightText.text,
                            stockQty: int.parse(_stockText.text),
                            lowStockQty: int.parse(_lowStockText.text),
                            sku: _skuText.text,
                            price: int.parse(_priceText.text),
                            description: _desText.text,
                            collection: dropdownValue,
                            comparedPrice: int.parse(_comPriceText.text),
                            productId: widget.productId,
                            image: image,
                            category: _categoryText.text,
                            subCategory: _subCategoryText.text,
                            categoryImage: categoryImage,
                          );
                          EasyLoading.dismiss();
                        }
                        provider.resetData();
                      }
                    },
                    title: 'Save',
                    color: red,
                    textColor: white
                ),
              ),
            ),
          ],
        )
      ),
      body:doc == null ?
      Center(child: CircularProgressIndicator())
      :Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixText: 'SKU',
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none
                        ),
                        controller: _skuText,
                        style: TextStyle(
                            fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none
                        ),
                        controller: _productNameText,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none
                      ),
                      controller: _weightText,
                      style: TextStyle(color: grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 90,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixText: '\$',
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _priceText,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          width: 90,
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixText: '\$',
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _comPriceText,
                            style: TextStyle(
                                fontSize: 15,
                              decoration: TextDecoration.lineThrough
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: red
                          ),
                          child: Text(
                            '${discount.toStringAsFixed(0)}% OFF',
                            style: TextStyle(
                              color: white
                            ),
                          ),
                        )
                      ],
                    ),
                    labelWidget(label: 'Inclusive of all Taxes', color: greyAc, size: 12
                    ),
                    getImageButton(
                      onTap: (){
                        provider.getImage().then((image){
                          if(mounted){
                            setState((){
                              _image = image;
                            });
                          }
                        });
                    }),
                    labelWidget(label: 'About this product', color: black, size: 20),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _desText,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: grey,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        children: [
                          labelWidget(label: 'Category', color: grey, size: 16),
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
                                controller: _categoryText,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _editing ? false : true,
                            child: IconButton(
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
                                      _categoryText.text= provider.selectedCategory!;
                                      _visible = true;
                                    });
                                  }
                                });
                              } ,
                            ),
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
                            labelWidget(label: 'Sub Category', color: grey, size: 16),
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
                                  controller: _subCategoryText,
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
                                      _subCategoryText.text= provider.selectedSubCategory!;
                                    });
                                  }
                                });
                              } ,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          labelWidget(label: 'Collection', color: black, size: 18),
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
                    Row(
                      children: [
                        labelWidget(label: 'Stock : ', color: black, size: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _stockText,
                            style: TextStyle(color: grey),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        labelWidget(label: 'Low Stock : ', color: black, size: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none
                            ),
                            controller: _lowStockText,
                            style: TextStyle(color: grey),
                          ),
                        )
                      ],
                    ),
                    SizedBox( height: 50)
                  ],
                ),
              )
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

  Widget getImageButton({required VoidCallback onTap}) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.all(8),
      child: _image != null
      ? Image.file(_image as File, height: 300)
      : Image.network(image, height: 300),
      ),
    );

  Widget labelWidget({required String label, required Color color, required double size}) => Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: size,
    ),
  );

  Widget buttonWidget({required VoidCallback ontap,required String title,required Color color, required Color textColor}) => InkWell(
    onTap: ontap,
    child: Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: textColor
          ),
        ),
      ),
    ),
  );
}

