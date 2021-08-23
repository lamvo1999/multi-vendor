import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context,){
      showModalBottomSheet(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (context, StateSetter myState){
                return Container(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: auth.error.isNotEmpty ? true:false,
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
                        TextField(
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
                              myState((){
                                _validPhoneNumber = true;
                              });
                            } else{
                              myState((){
                                _validPhoneNumber = false;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: _validPhoneNumber ? false: true,
                                child: _loginPhoneButton(() {
                                  myState((){
                                    auth.loading =true;
                                  });
                                  String number = '+84${_phoneNumberController.text}';
                                  auth.verifyPhone(
                                    context,
                                    number,
                                  ).then((value){
                                    _phoneNumberController.clear();
                                  });
                                },
                                  auth,
                                  _validPhoneNumber
                                )
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          )
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Flexible(
                  fit: FlexFit.loose,
                  child: Image.asset('assets/images/gps.png')),
              SizedBox(height: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Xác nhận địa điểm nhận hàng của bạn",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Sẵn sàng đặt hàng từ cửa hàng gần nhất?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: grey
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _setLocationLoginButton(
                        () async{
                      setState(() {
                        locationData.loading = true;
                      });
                      await locationData.getCurrentPosition();
                      if(locationData.permissionAllowed ==true){
                        Navigator.pushNamed(context, MAP);
                        setState((){
                          locationData.loading =false;
                        });
                      }else {
                        print("Permission not allowed");
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    }
                    , locationData)
                  ),
                ],
              ),
              _showFormLoginButton(
                  (){
                  setState((){
                    auth.screen = LOGIN;
                  });
                  showBottomSheet(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginPhoneButton(GestureTapCallback? onPresed, AuthProvider auth, bool _validPhoneNumber) =>TextButton(
    onPressed:onPresed,
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

  Widget _setLocationLoginButton(GestureTapCallback? onPressed, LocationProvider locationData) =>TextButton(
    onPressed: () async{
      setState(() {
        locationData.loading = true;
      });
      await locationData.getCurrentPosition();
      if(locationData.permissionAllowed ==true){
        Navigator.pushNamed(context, MAP);
        setState((){
          locationData.loading =false;
        });
      }else {
        print("Permission not allowed");
        setState(() {
          locationData.loading = false;
        });
      }
    },
    child:locationData.loading
        ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(white),
    )
        :Text(
      "XÁC NHẬN ĐỊA ĐIỂM",
      style: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w500
      ),
    ),
    style: TextButton.styleFrom(
      backgroundColor: primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: white,
        ),
      ),
    ),
  );

  Widget _showFormLoginButton(GestureTapCallback? onPressed) =>GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.all(8),
      child: RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Đả có tài khoản? ',
                  style: TextStyle(
                      color: black
                  )
              ),
              TextSpan(
                text: "Đăng Nhập",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: black
                ),
              ),
            ]
        ),
      ),
    ),
  );
}
