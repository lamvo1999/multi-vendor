import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LatLng currentLocation = LatLng(37.4219983,-122.084);
  late GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser()  {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if(user != null) {
      setState(() {
        _loggedIn = true;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude ?? 0.0 , locationData.longitude ?? 0.0);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return SafeArea(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation, zoom: 14.4746
            ),
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            onCameraMove: (CameraPosition position) {
              setState(() {
                _locating = true;
              });
              locationData.onCameraMove(position);
            },
            onMapCreated: onCreated,
            onCameraIdle: (){
              setState((){
                _locating = false;
              });
              locationData.getMoveCamera();
            },
          ),
          Center(
            child: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 40),
              child: Image.asset('assets/images/locato.png'),
            ),
          ),
          Center(
            child: SpinKitPulse(
              color: black,
              size: 100.0,
            )
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              height:200,
              width: MediaQuery.of(context).size.width,
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _locating ? LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(orange),
                  ) : Container(),
                  // Text(locationData.featuName.toString()),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.location_searching, color: orange,),
                      label:  Text(_locating ? 'Locating...' :
                          locationData.selectedAddress == null ? 'Locating...'
                          :locationData.selectedAddress.featureName,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: black
                        )
                        ,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      _locating
                          ? '' : locationData.selectedAddress == null ? ''
                          :locationData.selectedAddress.addressLine,
                      style: TextStyle(
                        fontSize: 12,
                        color: blue,
                        decoration: TextDecoration.none
                      ),
                    ),
                  ),
                  _setLocationButton(_auth, locationData)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLocationAddressWidget(LocationProvider locationData) => Padding(
    padding: const EdgeInsets.only(left: 10, right: 20),
    child: TextButton.icon(
      onPressed: () {},
      icon: Icon(Icons.location_searching, color: orange,),
      label:  Text(_locating ? 'Locating...'
          :locationData.selectedAddress.featureName,
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: black
        )
        ,),
    ),
  );

  Widget _setLocationButton(AuthProvider _auth, LocationProvider locationData)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: SizedBox(
        width: MediaQuery.of(context).size.width-40,
        child: AbsorbPointer(
          absorbing: _locating ? true : false,
          child: TextButton(
            onPressed: () {
              locationData.savePrefs();
              if(_loggedIn==false) {
                Navigator.pushNamed(context, LOGIN_PHONE);
              }else {
                setState((){
                  _auth.latitude = locationData.latitude;
                  _auth.longitude = locationData.longitude;
                  _auth.address = locationData.selectedAddress.addressLine;
                  _auth.featureName = locationData.selectedAddress.featureName;
                });
                _auth.updateUser(
                  id: user!.uid,
                  number: user!.phoneNumber,
                );
                Navigator.pushReplacementNamed(context, MAIN);
              }
            },
            child:Text(
              "XÁC NHẬN ĐỊA ĐIỂM",
              style: TextStyle(
                  color: white
              ),
            ),
            style: TextButton.styleFrom(
                backgroundColor: _locating ? grey : orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                )
            ),
          ),
        )
    ),
  );
}
