import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({Key? key}) : super(key: key);

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {

  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: auth.error == 'Mã OTP không hợp lệ' ? true:false,
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            auth.error,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12
                            ),
                          ),
                          SizedBox(height: 3),
                        ],
                      )
                  ),
                ),
                Text('Đăng Nhập',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text('Nhập số điện thoại để tiến hành đăng nhập',
                    style: TextStyle(
                        fontSize: 12,
                        color: grey
                    )
                ),
                SizedBox(height: 20),
                _inputPhoneWidget(),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false: true,
                        child: _loginPhoneButton(
                            () {
                              setState((){
                                auth.loading =true;
                                auth.screen = MAP;
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address = locationData.selectedAddress.addressLine;
                              });
                              String number = '+84${_phoneNumberController.text}';
                              auth.verifyPhone(
                                context,
                                number,

                              ).then((value){
                                _phoneNumberController.clear();
                                setState((){
                                  auth.loading = false;
                                });
                              });
                            },
                            auth,
                            locationData),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputPhoneWidget() => TextField(
    decoration: InputDecoration(
        prefixText: '+84',
        labelText: 'Nhập số điện thoại'
    ),
    autofocus: true,
    keyboardType: TextInputType.phone,
    maxLength: 9,
    controller: _phoneNumberController,
    onChanged: (value){
      if(value.length == 9){
        setState((){
          _validPhoneNumber = true;
        });
      } else{
        setState((){
          _validPhoneNumber = false;
        });
      }
    },
  );

  Widget _loginPhoneButton(GestureTapCallback? onPressed, AuthProvider auth, LocationProvider locationData) => TextButton(
    onPressed: onPressed,
    child:auth.loading
        ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(white),
    )
        :Text(
      _validPhoneNumber
          ? 'TIẾP TỤC'
          :'NHẬP SỐ ĐIỆN THOẠI',
      style: TextStyle(
          color: black
      ),
    ),
    style: TextButton.styleFrom(
      backgroundColor: _validPhoneNumber?orange: grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}
