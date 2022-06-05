import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/cliente/ordenes/detalle/encamino/cliente_orden_detalle_encamino_page.dart';
import 'package:reciclon_client/src/pages/cliente/ordenes/detalle/pagado/cliente_orden_detalle_pagado_page.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteOrdenesListaController {
  late BuildContext context;
  late Function refresh;
  User? user;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  bool? isUpdated;
  final List<String> status = [
    "PAGADO",
    "EN CAMINO",
    "ENTREGADO",
  ];

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
    if (user != null) {
      List<Orden> ordenes =
          await _ordenesProvider.getOrdersOfClientByStatus(status, user!.id!);
      // inspect(ordenes);
      return ordenes;
    } else {
      return [];
    }
  }

  void goToDetalleOrdenPage(Orden orden) async {
    // validar el status de la orden
    if (orden.status == 'PAGADO') {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => ClienteOrdenDetallePagadoPage(orden: orden),
          // settings: RouteSettings(
          //   name: 'delivery/ordenes/detalle/map/page',
          // ),
        ),
      );
    } else if (orden.status == 'EN CAMINO') {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => ClienteOrdenDetalleEncaminoPage(orden: orden),
        ),
      );
    } else if (orden.status == 'ENTREGADO') {}

    if (isUpdated == true) {
      refresh();
    }
  }

  void logout(BuildContext context) {
    _preferencias.logout(context, user!.id!);
  }

  void openDrawer(BuildContext context) {
    key.currentState!.openDrawer();
    // key.currentState.openEndDrawer();
  }

  void goToRoles(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToHomePage(BuildContext context) {
    Navigator.pushNamed(context, "cliente/home");
  }

  void goToProductos(BuildContext context) {
    Navigator.pushNamed(context, 'cliente/home');
  }
}
