import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/provider/vendor/auth_vendor_provider.dart';
import 'package:multi_vendor_app/widgets/vendor/not_vendor.dart';
import 'package:multi_vendor_app/widgets/vendor/vendor_data.dart';
import 'package:provider/provider.dart';

class MyVendorScreen extends StatefulWidget {
  const MyVendorScreen({Key? key}) : super(key: key);

  @override
  _MyVendorScreenState createState() => _MyVendorScreenState();
}

class _MyVendorScreenState extends State<MyVendorScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final _authVendor = Provider.of<AuthVendorProvider>(context);
    _authVendor.checkOwnVendor(user!.uid);
    return Container(
      child: _authVendor.checkVendor
      ? OwnVendorWidget()
      :NotDataVendorWidget(),
    );
  }
}
