import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClienteAddressMapController {
  late BuildContext context;
  late Function refresh;
  late Position _posicion;
  late String addressName = '';
  late LatLng addressLatLng;
  bool isLocationEnable = false;

  CameraPosition posisionInicial = CameraPosition(
    target: LatLng(-13.5344442, -71.9058763),
    zoom: 18,
    // zoom: 14.4746,
  );

  final Completer<GoogleMapController> _mapController = Completer();

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
  }

  void onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(
    //     '[{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]');
    _mapController.complete(controller);
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'lng': addressLatLng.longitude,
    };
    Navigator.pop(context, data);
  }

  Future animatedCameraToPosition(double lat, double lng) async {
    // inspect(_mapController.future);
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 18,
          bearing: 0,
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); //obtener la posicion actual y los permisos
      _posicion = (await Geolocator
          .getLastKnownPosition())!; //latitud y longitud actual
      animatedCameraToPosition(_posicion.latitude, _posicion.longitude);
    } on Exception catch (e) {
      print(e);
    }
  }

  void checkGPS() async {
    isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  void miPosicion() async {
    isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future<void> setLocationDragableInfo() async {
    double lat = posisionInicial.target.latitude;
    double lng = posisionInicial.target.longitude;
    try {
      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      inspect(address);
      if (address.isNotEmpty) {
        String? direccion = address[3].name;
        String? calle = address[2].name;
        String? city = address[0].locality;
        String? lugar = address[4].name;
        // String? departament = address[1].name;
        // String? country = address[0].country;
        addressName = '$calle, $direccion, $lugar ,$city';
        // print(country);
        addressLatLng = LatLng(lat, lng);
        refresh();
      }
    } on Exception catch (e) {
      inspect(e);
    }
  }
}
