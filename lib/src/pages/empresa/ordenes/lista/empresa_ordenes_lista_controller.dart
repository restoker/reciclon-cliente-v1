import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/empresa/ordenes/detalle/pagado/empresa_ordenes_detalle_pagado_page.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class EmpresaOrdenesListaController {
  late BuildContext context;
  late Function refresh;
  User? user;
  bool? isUpdated;
  final List<String> status = [
    "PAGADO",
    "DESPACHADO",
    "EN CAMINO",
    "ENTREGADO",
  ];

  final key = GlobalKey<ScaffoldState>();
  final _preferencias = SharedPref();
  final _ordenesProvider = OrdenesProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _preferencias.leer('user'));
    _ordenesProvider.init(context, user);
    refresh();
  }

  Future<List<Orden>> getOrdenes(String status) async {
    // List<Orden> ordenes = await _ordenesProvider.getCategoriasByStatus(status);
    // // inspect(ordenes);
    // return ordenes;

    if (user != null) {
      List<Orden> ordenes =
          await _ordenesProvider.getCategoriasByStatus(status);
      // inspect(ordenes);
      return ordenes;
    } else {
      return [];
    }
  }

  void goToDetalleOrdenPage(Orden orden) async {
    // validar el status de la orden
    if (orden.status == 'PAGADO') {
      isUpdated = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => EmpresaOrdenesDetallePagadoPage(orden: orden),
        ),
      );
    } else if (orden.status == 'DESPACHADO') {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) =>
      //         RestauranteOrdenesDetallesDespachadoPage(orden: orden),
      //   ),
      // );
    } else if (orden.status == 'EN CAMINO') {
    } else if (orden.status == 'ENTREGADO') {}

    if (isUpdated == true) {
      refresh();
    }
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToProductoCreate() {
    Navigator.pushNamed(context, 'empresa/productos/crear');
  }

  void goToAdminDelivery() {
    Navigator.pushNamed(context, 'empresa/recolector/crear');
  }

  void logout() {
    if (user == null) return;
    _preferencias.logout(context, user!.sessionToken!);
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
