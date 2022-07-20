import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as location;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

class RecolectorOrdenDetalleEncaminoController {
  late BuildContext context;
  late Function refresh;
  late Orden orden;
  late Position _posicion;
  late String addressName = '';
  late LatLng addressLatLng;
  late IO.Socket socket;
  User? user;
  bool esInstanciado = false;
  late BitmapDescriptor deliveryMarker;
  late BitmapDescriptor clientMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late StreamSubscription _positionStream;
  late double distanceBetween;

  final _preferencias = SharedPref();
  final _ordenesProvider = OrdenesProvider();

  CameraPosition posisionInicial = CameraPosition(
    target: LatLng(-13.5344442, -71.9058763),
    zoom: 20,
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
    user = User.fromJson(await _preferencias.leer('user'));
    _ordenesProvider.init(context, user);
    deliveryMarker = await crearMarker('assets/img/camion-de-basura.png');
    clientMarker = await crearMarker('assets/img/reciclaje.png');
    emitirOrdenDespachada();
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

  void saveLocation() async {
    final Map<String, dynamic> orden = {
      'id': this.orden.id,
      'lat': _posicion.latitude,
      'lng': _posicion.longitude,
    };

    await _ordenesProvider.actualizarLatLngDelivery(orden);
  }

  void emitirPosicionActual() {
    socket.emit('posicion', {
      'id_order': orden.id,
      'lat': _posicion.latitude,
      'lng': _posicion.longitude,
    });
  }

  void emitirOrdenDespachada() {
    socket.emit('despachado', {
      'id_order': orden.id,
    });
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'lng': addressLatLng.longitude,
    };
    Navigator.pop(context, data);
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

  void dispose() {
    _positionStream.cancel();
    socket.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); //obtener la posicion actual y los permisos
      _posicion = (await Geolocator
          .getLastKnownPosition())!; //latitud y longitud actual
      saveLocation();
      animatedCameraToPosition(_posicion.latitude, _posicion.longitude);
      addMarkerToMap(
        'recolector',
        _posicion.latitude,
        _posicion.longitude,
        'Mi posición',
        '',
        deliveryMarker,
      );
      addMarkerToMap(
        'Home',
        orden.direccion!.lat,
        orden.direccion!.lng,
        'Lugar de recojo',
        '',
        clientMarker,
      );

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );

      _positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position posicion) {
          _posicion = posicion;
          emitirPosicionActual();
          addMarkerToMap(
            'recolector',
            _posicion.latitude,
            _posicion.longitude,
            'Mi posición',
            '',
            deliveryMarker,
          );

          animatedCameraToPosition(_posicion.latitude, _posicion.longitude);
          isCloseToDeliveryPositioned();
          refresh();
        },
      );
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
    launch("tel://${orden.cliente!.telefono}");
  }

  void isCloseToDeliveryPositioned() {
    distanceBetween = Geolocator.distanceBetween(
      _posicion.latitude,
      _posicion.longitude,
      orden.direccion!.lat,
      orden.direccion!.lng,
    );
    // print('---DIstancia: ---:  $distanceBetween');
  }

  void actualizarOrdenAEntregado() async {
    Map<String, String> ordenIds = {
      'id': orden.id.toString(),
      'id_recolector': user!.id.toString(),
    };

    if (distanceBetween > 50) {
      MySnackbar.show(context,
          'No puede entregar su orden sin estar cerca a su posicion de entrega');
      return;
    }

    Loading.show(context);

    ResponseApi? respuesta =
        await _ordenesProvider.actualizarOrdenToEntregado(ordenIds);
    if (respuesta != null) {
      Navigator.pop(context);
      if (respuesta.success == true) {
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   'delivery/ordenes/detalle/map',
        //   (route) => false,
        //   arguments: orden.toJson(),
        // );
        Navigator.pushNamedAndRemoveUntil(
            context, 'recolector/home', (route) => false);
        // Navigator.of(context).pushAndRemoveUntil<bool>(
        //   MaterialPageRoute<bool>(
        //     builder: (_) => DeliveryOrdenesDetalleMapPage(),
        //   ),
        //   (route) => false,
        // );
      } else {
        MySnackbar.show(
            context, 'No se pudo actualizar la orden, intentelo nuevamente');
      }
    } else {
      Navigator.pop(context);
      MySnackbar.show(context, 'Ocurrrio un error con el servidor');
    }
  }

  void launchGoogleMaps() async {
    final url =
        'google.navigation:q=${orden.direccion!.lat.toString()},${orden.direccion!.lng.toString()}';
    final fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${orden.direccion!.lat.toString()},${orden.direccion!.lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}
