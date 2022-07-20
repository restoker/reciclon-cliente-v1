import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class RolesController {
  late BuildContext context;
  User? user;
  late Function refresh;

  final preferencias = SharedPref();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    bool existeUsuario = await preferencias.tiene('user');
    if (existeUsuario) {
      user = User.fromJson(await preferencias.leer('user'));
      refresh();
    }
  }

  void goToPage(String ruta) {
    Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
  }
}
