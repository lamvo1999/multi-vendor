import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_vendor_app/model/constants.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/vendor_provider.dart';
import 'package:multi_vendor_app/services/vendor_services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NearByVendors extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    VendorServices _vendorServices = VendorServices();
    PaginateRefreshedChangeListener refreshedChangeListener = PaginateRefreshedChangeListener();
    final _vendorData = Provider.of<VendorProvider>(context);
    _vendorData.getUserLocationData(context);

    getDistanceInKm(location,userLatitude ,userLongitude){
      var distance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          location['latitude']?? 0.0,
          location['longitude']?? 0.0);
      return distance/1000;
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
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: white,
      ),
      child: Column(
        children: [
          titleNearByWidget(),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _vendorServices.getVerifyedVendors(),
              builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData) return CircularProgressIndicator();
                if(hasNearByUser(snapshot, _vendorData.userLatitude, _vendorData.userLongitude)) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RefreshIndicator(
                          child: PaginateFirestore(
                            bottomLoader: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(primary),
                              ),
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilderType: PaginateBuilderType.listView,
                            itemBuilder: (index, context, document) =>
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 100,
                                      height : 110,
                                      child: Card(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.network(
                                              document['imageUrl'],
                                              fit: BoxFit.cover,)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
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
                                          SizedBox(height: 3),
                                          Text(
                                            document['dialog'],
                                            overflow: TextOverflow.ellipsis,
                                            style: storeCartStyle,
                                          ),
                                          SizedBox(height: 3),
                                          Container(
                                            width: MediaQuery.of(context).size.width-250,
                                            child: Text(
                                              document['location.address'],
                                              overflow: TextOverflow.ellipsis,
                                              style: storeCartStyle
                                            )
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                              '${getDistance(document['location'], _vendorData.userLatitude, _vendorData.userLongitude)}Km',
                                              overflow: TextOverflow.ellipsis,
                                              style: storeCartStyle
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.star, size: 12, color: grey),
                                              SizedBox(width: 4),
                                              Text(
                                                '3.2',
                                                style: storeCartStyle
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                                )
                              ),
                            ),
                            query: _vendorServices.getVerifyedVendorsPagination(),
                            listeners: [
                              refreshedChangeListener,
                            ],
                          ),
                          onRefresh: ()async {
                            refreshedChangeListener.refreshed = true;
                          }
                      )
                    ],
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }

  Widget titleNearByWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 8, right: 8, top: 20
        ),
        child: Text(
          'All Nearby Vendors',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: 8, right: 8
        ),
        child: Text(
          'Findout quality products near you',
          style: storeCartStyle
        ),
      ),
    ],
  );

}
