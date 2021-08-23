import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor_provider.dart';
import 'package:multi_vendor_app/services/user_services.dart';
import 'package:multi_vendor_app/services/vendor_services.dart';
import 'package:provider/provider.dart';

class TopRatingVendor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    VendorServices _vendorServices = VendorServices();
    final _vendorData = Provider.of<VendorProvider>(context);
    _vendorData.getUserLocationData(context);

    getDistanceInKm(location,userLatitude ,userLongitude){
      var distance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          location['latitude']?? 0.0,
          location['longitude']?? 0.0);
      return (distance/1000);
    }

    bool hasNearByUser(vendors, userLatitude, userLongitude) {
      List shopDistance = [];
      for (int i = 0; i < vendors.data.docs.length; i++) {
        var distance = getDistanceInKm(
            vendors.data.docs[i]['location'],userLatitude, userLongitude
        );
        shopDistance.add(distance);
      }
      shopDistance.sort();
      return shopDistance.first >10;
    }

    getDistance(location, userLatitude, userLongitude) {
      var distance = getDistanceInKm(location, userLatitude, userLongitude);
      return distance.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _vendorServices.getVendorByTopRating(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(hasNearByUser(snapshot, _vendorData.userLatitude, _vendorData.userLongitude)) {
            return noTopRatingNearBy(context);
          }
          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white,
            ),
            height: 210,
            child: Padding(
              padding:  EdgeInsets.only(left: 8, right :8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTopVendor(),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        if(double.parse(getDistance(document['location'], _vendorData.userLatitude, _vendorData.userLongitude)) <= 10){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Card(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.network(
                                              document['imageUrl'],
                                              fit: BoxFit.cover,)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 35,
                                      child: Text(
                                        document['vendorName'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                        '${getDistance(document['location'], _vendorData.userLatitude, _vendorData.userLongitude)}Km',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: grey
                                        )
                                    )
                                  ],
                                )
                            ),
                          );
                        }
                        else {
                          return Container();
                        }

                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noTopRatingNearBy(context) => Padding(
    padding: const EdgeInsets.only(bottom:30, top: 30, left: 20, right: 20),
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                "Currently we are not servicing in your area, \nPlease try later or try another location",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: black,
                    fontSize: 20
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget titleTopVendor() => Padding(
    padding: const EdgeInsets.only(top: 20, bottom :10),
    child: Row(
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Image.asset('assets/images/like.gif'),
        ),
        Text(
          "Top Rating Vendor For You",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20
          ),
        )
      ],
    ),
  );

}

