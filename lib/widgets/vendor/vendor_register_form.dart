import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:multi_vendor_app/provider/vendor/auth_vendor_provider.dart';
import 'package:provider/provider.dart';

class VendorRegisterForm extends StatefulWidget {
  const VendorRegisterForm({Key? key}) : super(key: key);

  @override
  _VendorRegisterFormState createState() => _VendorRegisterFormState();
}

class _VendorRegisterFormState extends State<VendorRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String PHONE_NUMBER = "Phone Number";
  String? email;
  String? password;
  String? phone;
  String? vendorName;
  String? dialog;
  bool _isLoading = false;
  var _emailTextController = TextEditingController();
  var _phoneTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _dialogTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthVendorProvider>(context);

    scaffoldMessage(message){
      return ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
        content: Text(message),));
    }

    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primary),
    )
        :Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _inputFieldWidget(
              "Vendor Name",
              Icon(Icons.add_business_outlined),
              TextInputType.text,
              false,
              _nameTextController,
                  (value) {
                if(value!.isEmpty){
                  return "Enter Vendor Name";
                }
                setState((){
                  vendorName= value;
                });
                return null;
              }
          ),
          _inputFieldWidget(
              PHONE_NUMBER,
              Icon(Icons.phone_android_rounded),
              TextInputType.number,
              false,
              _phoneTextController,
                  (value) {
                if(value!.isEmpty){
                  return "Enter Vendor Phone Number";
                }
                setState((){
                  phone= value;
                });
                return null;
              }
          ),
          _inputFieldWidget(
              "Email",
              Icon(Icons.email_outlined),
              TextInputType.emailAddress,
              false,
              _emailTextController,
                  (value) {
                if(value!.isEmpty){
                  return "Enter Vendor Email";
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Invalid Email Formate';
                }
                setState(() {
                  email = value;
                });
                return null;
              }
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 5,
              controller: _addressTextController,
              validator: (value){
                if(value!.isEmpty){
                  return 'Please press Navigation Button';
                }
                if(_authData.vendorLatitude ==null) {
                  return 'Please press Navigation Button';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.place_outlined),
                  labelText: "Vendor Location",
                  suffixIcon: IconButton(
                    onPressed: (){
                      _addressTextController.text='Locating...\n Please wait...';
                      _authData.getCurrentVendor().then((address){
                        if(address!=null){
                          setState((){
                            _addressTextController.text = _authData.placeName!+"\n"+_authData.vendorAddress!;
                          });
                        }else {
                          ScaffoldMessenger
                              .of(context)
                              .showSnackBar(SnackBar(content: Text('Could not find location...')));
                        }
                      });
                    },
                    icon: Icon(Icons.location_searching),
                  ),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: primary
                      )
                  ),
                  focusColor: primary
              ),
            ),
          ),
          _inputFieldWidget(
              "Vendor Dialog",
              Icon(Icons.comment_outlined),
              TextInputType.text,
              false,
              _dialogTextController,
                  (value) {
                if(value!.isEmpty){
                  return "Enter Vendor Diolog";
                }
                setState((){
                  dialog= value;
                });
                return null;
              }
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () async{
                    if(_authData.isPicAvail==true){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });
                        _authData.uploadFile(_nameTextController.text).then((url) {
                          if(url!= null) {
                            _authData.saveVendorDataToDB(
                                url,
                                vendorName!,
                                email!,
                                phone!,
                                dialog!);
                            setState((){
                              _isLoading = false;
                            });
                            Navigator.pushReplacementNamed(context, VENDOR_DASHBOARD);
                          }else {
                            scaffoldMessage('Failed to upload shop profile pic');
                          }
                        });
                      }
                    }else {
                      scaffoldMessage('Shop profile pic need to be added');
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: Text("Register", style: TextStyle(color: white),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _inputFieldWidget( String label, Icon icon,TextInputType type,bool secur,TextEditingController controller, FormFieldValidator validator,) =>  Padding(
    padding: const EdgeInsets.all(3.0),
    child: TextFormField(
      validator: validator,
      controller: controller,
      maxLength: label == PHONE_NUMBER ? 9 : null,
      keyboardType: type,
      obscureText: secur,
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          prefixText: label == PHONE_NUMBER ? '+84' : null,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: primary
              )
          ),
          focusColor: primary
      ),
    ),
  );

}
