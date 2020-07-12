import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ManageBusSchedule extends StatefulWidget {
  @override
  _ManageBusScheduleState createState() => _ManageBusScheduleState();
}

class _ManageBusScheduleState extends State<ManageBusSchedule> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  _ManageBusScheduleState() {
    _locationTracker.requestPermission().then((value) {
      print(value.toString());
    });
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(16.245570, 103.250191),
    zoom: 15,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load('asset/icons/placeholder.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId('home'),
        position: latLng,
        rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData),
      );
      circle = Circle(
        circleId: CircleId('home'),
        radius: newLocalData.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        fillColor: Colors.blue.withAlpha(70),
      );
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocation) {
        if (_controller != null) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                target: LatLng(
                  newLocation.latitude,
                  newLocation.longitude,
                ),
                tilt: 0,
                zoom: 17.0,
              ),
            ),
          );
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('PERMISSION_DENIED');
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการตารางการเดินรถ',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Icon(Icons.access_alarm),
      ),
    );
  }
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(16.245570, 103.250191);
const LatLng DEST_LOCATION = LatLng(16.245570, 103.250191);

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = new PolylinePoints();
  String googleAPIKey = 'AIzaSyB86m0beaTOIfD1PqqPM0zYTLJfCWahEYc';
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  @override
  void initState() {
    super.initState();

    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    setSourceAndDestinationIcons();
    setInitialLocation();
    print(_markers.length);
    print(_polylines.length);
    print(polylineCoordinates.length);
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'asset/icons/driving-school.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'asset/icons/marker.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  void showPinsOnMap() {
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        icon: sourceIcon));
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position:
            LatLng(destinationLocation.latitude, destinationLocation.longitude),
        icon: destinationIcon));
    // setPolylines();
  }

  // void setPolylines() async {
  //   print(currentLocation.latitude);
  //   print(currentLocation.longitude);
  //   print(destinationLocation.latitude);
  //   print(destinationLocation.longitude);
  //   print(googleAPIKey);
  //   List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleAPIKey,
  //       currentLocation.latitude,
  //       currentLocation.longitude,
  //       destinationLocation.latitude,
  //       destinationLocation.longitude);
  //   if (result.isNotEmpty) {
  //     result.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //     setState(() {
  //       _polylines.add(Polyline(
  //           width: 5, // set the width of the polylines
  //           polylineId: PolylineId('poly'),
  //           color: Color.fromARGB(255, 40, 122, 198),
  //           points: polylineCoordinates));
  //     });
  //   }
  // }

  void updatePinOnMap() async {
    print(currentLocation.latitude.toString() +
        ' ' +
        currentLocation.longitude.toString());
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM, bearing: CAMERA_BEARING, target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จัดการตารางการเดินรถ',
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Color(0xFF3a3a3a),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                showPinsOnMap();
              })
        ],
      ),
    );
  }
}
