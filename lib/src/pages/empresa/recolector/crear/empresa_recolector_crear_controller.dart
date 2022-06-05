import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

import 'dart:async';

class EmpresaRecolectorCrearController {
  late BuildContext context;
  late Function refresh;
  User? user;
  Timer? searchStopTyping;
  late String userName = '';
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  List<User>? usuarios = [];

  final _preferencias = SharedPref();
  final _userProviders = UserProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _preferencias.leer('user'));
    _userProviders.init(context, sesionUser: user);
    // getUsers();
    refresh();
  }

  Future<List<User>?> getUsers() async {
    usuarios = await _userProviders.getUsersNoDelivery();
    // print(usuarios);
    return usuarios;
  }

  void onChangedText(String texto) {
    Duration duracion = Duration(milliseconds: 800);
    if (searchStopTyping != null) {
      searchStopTyping?.cancel();
      refresh();
    }
    searchStopTyping = Timer(duracion, () {
      userName = texto;
      refresh();
      // print(texto);
    });
  }

  Future<bool> crearUsuarioDelivery(String idUser) async {
    // print(id_user);

    Map<String, String> usuario = {"id_user": idUser};
    ResponseApi? respuesta =
        await _userProviders.actualizarUsuarioToDelivery(usuario);
    if (respuesta != null) {
      return respuesta.success;
    } else {
      return false;
    }
    // refresh();
  }

  void logout(BuildContext context) {
    if (user == null) return;
    _preferencias.logout(context, user!.sessionToken!);
  }

  void goToCategoryCreate() {
    Navigator.pushNamed(context, 'restaurante/categorias/crear');
  }

  void goToProductoCreate(BuildContext context) {
    Navigator.pushNamed(context, 'restaurante/producto/crear');
  }

  void goToAdminDelivery() {
    Navigator.pushNamed(context, 'restaurante/admin/delivery');
  }

  void openDrawer(BuildContext context) {
    key.currentState!.openDrawer();
  }

  void goToRoles(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
