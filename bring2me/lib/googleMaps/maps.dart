import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePageMap(),
    );
  }
}
 
class MyHomePageMap extends StatefulWidget {
  //final String title;
 
  @override
  _MyHomePageMapState createState() => _MyHomePageMapState();
}
 
class _MyHomePageMapState extends State<MyHomePageMap> {
  
  Completer<GoogleMapController> _controller = Completer();
    final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed(final lat, final long) {
    final _center = LatLng(lat, long);
    LatLng _lastMapPosition = _center;
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(      
        future: position(),
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.data != null){
          final docLat = snapshot.data.latitude;
          final docLong = snapshot.data.longitude;
            return Scaffold(
              appBar: AppBar(
                title: Text('LOCATION'),
                ),
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                        mapType: _currentMapType,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(docLat, docLong),
                          zoom: 14.4746,
                        ),
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);                              
                            },                
                        ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: <Widget>[
                              FloatingActionButton(
                              onPressed: (){
                                _onMapTypeButtonPressed();
                              },
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.map, size: 36.0),
                              ),
                              SizedBox(height: 16.0),
                              FloatingActionButton(
                              onPressed: (){
                                _goToTheLake(docLat, docLong);
                              },
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.pin_drop, size: 36.0),
                            ),
                              SizedBox(height: 16.0),
                              FloatingActionButton(
                                onPressed: (){
                                
                                  _onAddMarkerButtonPressed(docLat, docLong);
                              },
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.add_location, size: 36.0),
                            ),
                            ],
                          ),
                      ),
                    )
                  ],
                )

              );
        }
        else {
          return Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 385.0,),
                  Text("Cargando Map..."),
                  SizedBox(height: 15.0,),
                  /* CupertinoActivityIndicator(), */
                  CircularProgressIndicator()
                ],
              ),
            )
          );
        }
        });
    
  }
    Future<void> _goToTheLake(final docLat,final docLong) async {
    
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(docLat, docLong),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414)
      ));  
        

  }
   Future<LocationData> position() async {    
    LocationData currentLocation;
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } on PlatformException {
      currentLocation = null;
    }
  
    return currentLocation;
  } 

}

 
 



/* import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-0.997907, -78.583546),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-0.997907, -78.583546),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
} */