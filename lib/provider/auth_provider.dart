import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:multi_vendor_app/services/user_services.dart';

class AuthProvider with ChangeNotifier{

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String? screen;
  double? latitude;
  double? longitude;
  String? address;
  String? featureName;

  Future<void> verifyPhone(BuildContext context, String number) async{
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async{
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async{
      this.verificationId = verId;
      smsOtpDialog(context, number);
    };

    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            this.verificationId = verId;
          });
    }catch(e) {
      this.error= e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }

  }

  Future<bool?> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text('Mã Xác Nhận'),
              SizedBox(height: 6,),
              Text(
                "Nhập mã OTP được gửi về sms",
                style: TextStyle(
                  color: grey,
                  fontSize: 12
                ),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength:6,
              onChanged: (value) {
                this.smsOtp = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()async{
                try{
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId as String,
                          smsCode: smsOtp as String);

                  final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                  if(user!=null) {
                    this.loading = false;
                    notifyListeners();

                    DocumentSnapshot snapshot = await _userServices.getUserById(user.uid);
                    if(snapshot.exists){
                      if(this.screen ==LOGIN){

                        if(snapshot.get('location.address')){
                          Navigator.pushReplacementNamed(context, MAIN);
                        }else {
                          Navigator.pushReplacementNamed(context, LANDING);
                        }
                      }else{
                        updateUser(id: user.uid, number: user.phoneNumber);
                        Navigator.pushReplacementNamed(context, MAIN);
                      }
                    }else {
                      _createUser(id: user.uid, number: user.phoneNumber);
                      Navigator.pushReplacementNamed(context, LANDING);
                    }
                  }else{
                      showDialog(
                          context: context,
                          builder: (_) => new CupertinoAlertDialog(
                            title: new Text("Failed"),
                            content: new Text("Login Failed!"),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close!'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                  }
                }catch(e){
                  this.error = 'Mã OTP không hợp lệ';
                  notifyListeners();
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              }, 
              child: Text(
                "Hoàn Thành",
                style: TextStyle(
                  color:primary
                ),
              ),
            )
          ],
        );
      }).then((value) {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({required String id,String? number,}){
    _userServices.createUserData({
      'id':id,
      'number':number,
      'location': {
        'latitude': this.latitude,
        'longitude' : this.longitude,
        'address' : this.address,
        'featureName': this.featureName
      },
    });
    this.loading = false;
    notifyListeners();
  }

  Future<void> signOut()async {
    await _auth.signOut();
  }

  Future<bool> updateUser({required String id,String? number}) async{
   try{
     _userServices.updateUserData({
       'id':id,
       'number':number,
       'location': {
         'latitude': this.latitude,
         'longitude' : this.longitude,
         'address' : this.address,
         'featureName': this.featureName
       },
     });
     this.loading = false;
     notifyListeners();
     return true;
   }catch(e){
     print('Error $e');
     return false;
   }
  }

}