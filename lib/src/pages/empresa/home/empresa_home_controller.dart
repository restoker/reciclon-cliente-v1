import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class EmpresaHomeController {
  late BuildContext context;
  late Function refresh;
  User? user;
  final key = GlobalKey<ScaffoldState>();
  final _preferencias = SharedPref();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _preferencias.leer('user'));
    // _ordenesProvider.init(context, user);
    refresh();
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToProductoCreate() {
    Navigator.pushNamed(context, 'empresa/productos/crear');
  }

  void logout() {
    if (user == null) return;
    _preferencias.logout(context, user!.sessionToken!);
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
