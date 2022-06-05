import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/address.dart';
// import 'package:reciclon_client/src/models/orden.dart';
// import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/cliente/address/crear/cliente_address_crear_page.dart';
import 'package:reciclon_client/src/pages/cliente/stripe/crear/pago/cliente_stripe_crear_controller.dart';
import 'package:reciclon_client/src/providers/address_provider.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
// import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteAddressListaController {
  late BuildContext context;
  late Function refresh;
  User? user;
  List<Address> direcciones = [];
  int radioValue = 0;
  bool? isCreated;
  bool isEnable = false;
  String? idEmpresa = '';
  final stripePayment = ClienteStripeCrearController();

  final _addressProvider = AddressProvider();
  final _ordenProvider = OrdenesProvider();
  final _preferencias = SharedPref();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    idEmpresa = ModalRoute.of(context)!.settings.arguments as String;
    // inspect(idEmpresa);
    // print('El id de la empresa es: $idEmpresa');
    user = User.fromJson(await _preferencias.leer('user'));
    await _addressProvider.init(context, user);
    await _ordenProvider.init(context, user);
    // if (direcciones.isNotEmpty) {
    //   isEnable = true;
    // } else {
    //   isEnable = false;
    // }
    refresh();
  }

  Future<List<Address>> obtenerDirecciones() async {
    direcciones = await _addressProvider.getAddress(user!.id!);
    Map<String, dynamic>? direccionesPreferencia =
        await _preferencias.leer('address');
    // inspect(direccionesPreferencia);
    if (direccionesPreferencia != null) {
      Address address = Address.fromJson(direccionesPreferencia);
      int index =
          direcciones.indexWhere((direccion) => direccion.id == address.id);
      if (index != -1) {
        radioValue = index;
      }
    }
    // Address direccion =
    //     Address.fromJson(await _preferencias.leer('address') ?? {});
    // inspect(direcciones);
    // int index = direcciones.indexWhere((a) => a.id == direccion.id);
    // if (index != -1) {
    //   radioValue = index;
    // }
    return direcciones;
  }

  void handleRadioValueChange(int value) async {
    radioValue = value;
    await _preferencias.guardar('address', direcciones[value]);
    refresh();
    // print('valor seleccionado: $value');
  }

  void goToNewAddress() async {
    // Navigator.of(context).pushNamed('cliente/address/crear');

    isCreated = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ClienteAddressCrearPage(),
      ),
    );
    if (isCreated != null) {
      if (isCreated as bool) {
        isEnable = true;
        refresh();
      }
    }
  }

  void crearOrden() async {
    // print('pagar orden');
    final Address direccion =
        Address.fromJson(await _preferencias.leer('address'));
    // // inspect(direccion);
    if (direcciones.isEmpty) {
      MySnackbar.show(context, 'Debe agregar una dirección');
      return;
    }
    if (idEmpresa!.isEmpty) {
      MySnackbar.show(context, 'Debe agregar una dirección');
      return;
    }

    if (user == null) {
      MySnackbar.show(context, 'Su sesion expiro, vuelva a loguearse');
      return;
    }

    await stripePayment.makePayment(context, direccion, idEmpresa, user);

    // Loading.show(context);

    // final orden = Orden(
    //   idUser: user!.id!,
    //   idDireccion: direccion.id!,
    //   idEmpresa: idEmpresa!,
    //   lat: direccion.lat,
    //   lng: direccion.lng,
    // );

    // ResponseApi? respuesta = await _ordenProvider.crear(orden);
    // if (respuesta != null) {
    //   Navigator.pop(context);
    //   if (respuesta.success == true) {
    //     MySnackbar.show(context, respuesta.msg, isSuccess: true);
    //     // Navigator.pop(context);
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, 'cliente/home', (route) => false);
    //   } else {
    //     MySnackbar.show(context, 'No se pudo crear la dirección');
    //   }
    // }
  }
}
