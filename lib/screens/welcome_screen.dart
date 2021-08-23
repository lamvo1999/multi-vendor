
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_vendor_app/model/items.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';

class WelcomeScreen extends StatelessWidget {
  final _pageViewController = new PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait
      );
    return Scaffold(
      backgroundColor: Color(0xffe0e9f8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(45).toDouble(),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, LOGIN);
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              _imageCover(
                Items.welcomeData[index]['image']?? "",
              ),
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(375).toDouble(),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              4,
                                  (indicator) => Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: indicator == index
                                      ? blue
                                      : dot,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _descriptionWidgets(
                          Items.welcomeData[index]['title'] ?? "",
                          Items.welcomeData[index]['text']?? "",
                        ),
                        Spacer(),
                        _nextButton(
                              () {
                            if (index < 3) {
                              _pageViewController.animateToPage(index + 1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            } else {}
                          },
                          index,
                          context
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 4,
      ),
    );
  }

  Widget _imageCover(String? image) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
      image?? "",
      width: ScreenUtil().setWidth(326).toDouble(),
      height: ScreenUtil().setHeight(240).toDouble(),
    ),
  );

  Widget _nextButton( GestureTapCallback? onPressed, int? index, BuildContext? context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: index != 3
          ? Colors.transparent
          : blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: blue,
        ),
      ),
    ),
    child: Container(
      width: ScreenUtil().setWidth(160),
      height: 40,
      alignment: Alignment.center,
      child: index != 3 ? Text(
        'Next Step',
        style: TextStyle(
          color: blue,
          fontSize: ScreenUtil().setSp(16),
          fontWeight: FontWeight.bold,
        ),
      )
          :GestureDetector(
        onTap: (){
          Navigator.pushNamed(context!, LOGIN);
        },
        child: Text(
          'Let\'s Get Started',
          style: TextStyle(
            color: white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

Widget _descriptionWidgets(String? title, String? text) => Column(
  children: <Widget>[
    Text(
      title!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: black,
        fontSize: ScreenUtil().setSp(30).toDouble(),
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(
      height: 11,
    ),
    Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: primary,
        fontSize: ScreenUtil().setSp(15).toDouble(),
      ),
    ),
  ],
);
}


