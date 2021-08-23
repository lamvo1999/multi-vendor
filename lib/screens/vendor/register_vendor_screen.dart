import 'package:flutter/material.dart';
import 'package:multi_vendor_app/widgets/vendor/vendor_pic_card.dart';
import 'package:multi_vendor_app/widgets/vendor/vendor_register_form.dart';


class RegisterVendorScreen extends StatelessWidget {
  const RegisterVendorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    VendorPicCard(),
                    VendorRegisterForm(),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}



