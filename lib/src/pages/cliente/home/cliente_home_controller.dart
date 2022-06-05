import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/empresa_providers.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteHomeController {
  late BuildContext context;
  late Function refresh;
  User? user;
  final key = GlobalKey<ScaffoldState>();
  List<Empresa>? empresas = [];
  List<Empresa>? empresasAprobadas = [];

  final List<String> categorias = [
    "PLASTICO",
    "METALES",
    "VIDRIOS",
    "ORGANICOS",
    "PAPEL",
  ];

  final _preferencias = SharedPref();
  final _empresaProvider = EmpresaProviders();

  void init(BuildContext context, Function refresh) async {
    try {
      final userExiste = await _preferencias.tiene('user');
      if (userExiste) {
        user = User.fromJson(await _preferencias.leer('user'));
        _empresaProvider.init(context, user!);
        // inspect(user);
      }
    } on Exception catch (e) {
      print(e);
      return;
    }
    this.context = context;
    this.refresh = refresh;
    refresh();
  }

  Future<List<Empresa>?> getEmpresasPreAprobadas() async {
    empresas =
        await _empresaProvider.obtenerEmpresasPreAprobadas(user!.id.toString());
    // print(usuarios);
    // inspect(empresas);
    return empresas;
  }

  Future<List<Empresa>?> getEmpresasAprobadas(String categoria) async {
    empresas = await _empresaProvider.getEmpresasByCategorias(categoria);
    // print(usuarios);
    // inspect(empresas);
    return empresas;
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToUpdatePage(BuildContext context) {
    Navigator.pushNamed(context, 'cliente/update');
  }

  void goToCrearEmpresa() {
    Navigator.pushNamed(context, 'empresa/crear');
  }

  void goToOrdenesCliente() {
    Navigator.pushNamed(context, 'cliente/ordenes/lista');
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

class Categoria {
  String nombre;
  String imagen;
  Color color;

  Categoria({required this.nombre, required this.color, required this.imagen});
}
