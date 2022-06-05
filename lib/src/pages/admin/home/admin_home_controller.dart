import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class AdminHomeController {
  late BuildContext context;
  late Function refresh;
  User? user;
  final key = GlobalKey<ScaffoldState>();
  final _preferencias = SharedPref();

  void init(BuildContext context, Function refresh) async {
    try {
      final userExiste = await _preferencias.tiene('user');
      if (userExiste) {
        user = User.fromJson(await _preferencias.leer('user'));
        // inspect(user);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      }
    } on Exception catch (e) {
      print(e);
      return;
    }
    this.context = context;
    this.refresh = refresh;
  }

  void goToUpdatePage(BuildContext context) {
    Navigator.pushNamed(context, 'cliente/update');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToAdminEmpresas() {
    Navigator.pushNamed(context, 'admin/empresas');
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void logout() async {
    // await userProvider.logOut(idUser);
    try {
      await _preferencias.eliminar('orden');
      await _preferencias.eliminar('user');
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } on Exception catch (e) {
      print(e);
      MySnackbar.show(context, 'No se pudo cerrar sesión');
    }
  }
}
