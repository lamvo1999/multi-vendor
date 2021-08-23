import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const PHONE_NUMBER = 'number';
  static const ID = 'id';

  String? _number;
  String? _id;


  //getter
  String? get number => _number;
  String? get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _number = snapshot.get(PHONE_NUMBER);
    _id = snapshot.get(ID);
  }
}