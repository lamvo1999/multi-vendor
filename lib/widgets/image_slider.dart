import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_app/model/style.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  int _index = 0;
  int _dataLength = 1;
 @override
  void initState() {
    // TODO: implement initState
   getSliderImageFormDb();
    super.initState();
  }
 Future getSliderImageFormDb() async{
   var _firestore = FirebaseFirestore.instance;
   QuerySnapshot snapshot = await _firestore.collection('banner').get();
   if(mounted){
     setState((){
       _dataLength = snapshot.docs.length;
     });
   }
   return snapshot.docs;
 }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if(_dataLength!=0)
        FutureBuilder(
          future: getSliderImageFormDb(),
          builder: (_,AsyncSnapshot  snapshot) {
            return snapshot.data == null
                ? Center(
              child: CircularProgressIndicator(),
            ) :
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      initialPage: 0,
                      height: 150,
                      autoPlay: true,
                      viewportFraction: 1,
                      onPageChanged: (int i, carousePageChaged){
                        setState((){
                          _index = i;
                        });
                      }
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: ( context, int index, int pageViewIndex) {
                      DocumentSnapshot sliderImage = snapshot.data![index];
                      Map? getImage = sliderImage.data() as Map?;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                          child: Image.network(getImage!['image'], fit: BoxFit.fill,));
                    },
                  ),
                );
          },
        ),
        if(_dataLength!=0)
        DotsIndicator(
            dotsCount: _dataLength,
          position: _index.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 5.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            activeColor: primary
          ),
        ),
      ],
    );
  }
}
