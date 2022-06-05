import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/address.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/cliente/address/map/cliente_address_map_page.dart';
import 'package:reciclon_client/src/providers/address_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteAddressCrearController {
  late BuildContext context;
  late Function refresh;
  late User user;

  Map<String, dynamic>? refPoint;
  TextEditingController refPointController = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController barrio = TextEditingController();
  TextEditingController especificacionText = TextEditingController();

  final _preferencias = SharedPref();
  final addressProvider = AddressProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _preferencias.leer('user'));
    await addressProvider.init(context, user);
  }

  void goToMap() async {
    refPoint = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (_) => ClienteAddressMapPage(),
      ),
    );
    // refPoint = await Navigator.of(context)
    //     .pushNamed<Map<String, dynamic>>('cliente/address/map');
    if (refPoint != null) {
      refPointController.text = refPoint!['address'];
    }
  }

  void crearDireccion() async {
    String address = direccion.text;
    String neighborhood = barrio.text;
    String especificaciones = especificacionText.text;
    double lat = refPoint?['lat'] ?? 0;
    double lng = refPoint?['lng'] ?? 0;
    // validando los campos

    if (address.isEmpty ||
        neighborhood.isEmpty ||
        especificaciones.isEmpty ||
        lat == 0 ||
        lng == 0) {
      MySnackbar.show(context, 'Todos los campos son obligatorios');
      return;
    }

    if (refPoint == null) {
      MySnackbar.show(context, 'Debe ingresar las coordenadas de su dirección');
      return;
    }

    Loading.show(context);

    Address nuevaDireccion = Address(
      idUser: user.id!,
      direccion: address,
      barrio: neighborhood,
      especificacion: especificaciones,
      lat: lat,
      lng: lng,
    );

    ResponseApi? respuesta = await addressProvider.create(nuevaDireccion);
    // inspect(respuesta);

    if (respuesta != null) {
      MySnackbar.show(context, respuesta.msg, isSuccess: respuesta.success);
      Navigator.pop(context);
      if (respuesta.success == true) {
        nuevaDireccion.id = respuesta.data;
        _preferencias.guardar('address', nuevaDireccion);
        direccion.text = '';
        especificacionText.text = '';
        barrio.text = '';
        MySnackbar.show(context, respuesta.msg, isSuccess: true);
        // Navigator.pop(context);
        Navigator.pop(context, true);
      } else {
        MySnackbar.show(context, 'No se pudo crear la dirección');
      }
    } else {
      MySnackbar.show(context, 'No se pudo crear la dirección');
      Navigator.pop(context);
    }
  }
}
