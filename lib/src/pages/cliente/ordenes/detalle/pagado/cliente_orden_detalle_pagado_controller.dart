import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteOrdenDetallePagadoController {
  late BuildContext context;
  late Function refresh;
  User? user;
  late Orden orden;

  final _preferencias = SharedPref();
  // final _ordenesProvider = OrdenesProvider();

  void init(BuildContext context, Function refresh, Orden orden) async {
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    user = User.fromJson(await _preferencias.leer('user'));
    // _ordenesProvider.init(context, user);
    refresh();
  }
}
