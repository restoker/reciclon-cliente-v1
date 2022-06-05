import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClienteOrdenDetalleEncaminoController {
  late BuildContext context;
  late Function refresh;
  late Orden orden;
  // late Position _posicion;
  late String addressName = '';
  late LatLng addressLatLng;
  User? user;
  late IO.Socket socket;
  bool esInstanciado = false;
  late BitmapDescriptor recolectorMarker;
  late BitmapDescriptor clientMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late double distanceBetween;

  CameraPosition posisionInicial = CameraPosition(
    target: LatLng(-13.5344442, -71.9058763),
    zoom: 14,
    // zoom: 14.4746,
  );

  final Completer<GoogleMapController> _mapController = Completer();

  void init(BuildContext context, Function refresh, Orden orden) async {
    // Loading.show(context);
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    esInstanciado = true;
    // socket = IO.io('http://${Enviroment.apiDelivery}/ordenes/recolector',
    socket = IO.io('https://${Enviroment.apiDelivery}/ordenes/recolector',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.connect();
    recivirPosicionActual();
    recivirOrdenDespachada();
    // user = User.fromJson(await _preferencias.leer('user'));
    // _ordenesProvider.init(context, user);
    recolectorMarker = await crearMarker('assets/img/camion-de-basura.png');
    clientMarker = await crearMarker('assets/img/reciclaje.png');
    checkGPS();
    refresh();
  }

  void addMarkerToMap(String markerId, double lat, double lng, String titulo,
      String contenido, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: titulo, snippet: contenido),
    );
    markers[id] = marker;
    refresh();
  }

  void recivirPosicionActual() {
    socket.on('posicion/${orden.id}', (data) {
      addMarkerToMap(
        'recolector',
        data['lat'],
        data['lng'],
        'El recolector',
        '',
        recolectorMarker,
      );
    });
  }

  void recivirOrdenDespachada() {
    socket.on('despachado/${orden.id}', (data) {
      Navigator.pushNamedAndRemoveUntil(
          context, 'cliente/home', (route) => false);
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future animatedCameraToPosition(double lat, double lng) async {
    // inspect(_mapController.future);
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 13,
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

  void dispose() {
    socket.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); //obtener la posicion actual y los permisos

      animatedCameraToPosition(orden.direccion!.lat, orden.direccion!.lng);
      addMarkerToMap(
        'recolector',
        orden.lat,
        orden.lng,
        'El recolector',
        '',
        recolectorMarker,
      );
      addMarkerToMap(
        'Home',
        orden.direccion!.lat,
        orden.direccion!.lng,
        'Yo',
        '',
        clientMarker,
      );
      refresh();
    } on Exception catch (e) {
      print(e);
    }
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
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
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> crearMarker(String path) async {
    // info: https://stackoverflow.com/questions/53633404/how-to-change-the-icon-size-of-google-maps-marker-in-flutter

    // ImageConfiguration configuracion = ImageConfiguration();
    // BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuracion, path);
    final Uint8List markerIcon = await getBytesFromAsset(path, 110);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);

    return descriptor;
  }

  void call() {
    launch("tel://${orden.recolector!.telefono}");
  }
}
