import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/empresa_providers.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class AdminEmpresasController {
  late BuildContext context;
  late Function refresh;
  late User user;
  Timer? searchStopTyping;
  late String userName = '';
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  List<Empresa>? empresas = [];

  final _preferencias = SharedPref();
  final _userProviders = UserProvider();
  final _empresaProvider = EmpresaProviders();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    bool usuarioExiste = await _preferencias.tiene('user');
    if (usuarioExiste) {
      user = User.fromJson(await _preferencias.leer('user'));
      _userProviders.init(context, sesionUser: user);
      _empresaProvider.init(context, user);
      // getUsers();
      refresh();
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  Future<List<Empresa>?> getEmpresasPreAprobadas() async {
    empresas =
        await _empresaProvider.obtenerEmpresasPreAprobadas(user.id.toString());
    // print(usuarios);
    // inspect(empresas);
    return empresas;
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

  void goToUpdatePage(BuildContext context) {
    Navigator.pushNamed(context, 'cliente/update');
  }

  void openDrawer(BuildContext context) {
    key.currentState!.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
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

  Future<bool> aprobarEmpresa(String idEmpresa) async {
    Map<String, String> data = {
      "id_user": user.id.toString(),
      "id_empresa": idEmpresa,
    };
    ResponseApi? respuesta =
        await _empresaProvider.actualizarEmpresaToAprobada(data);
    if (respuesta != null) {
      return respuesta.success;
    } else {
      return false;
    }
  }
}
