import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/producto.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/productos_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteEmpresaDetalleController {
  late BuildContext context;
  late Function refresh;
  User? user;
  List<Producto>? productos;

  final _preferencias = SharedPref();
  final _productosProvider = ProductosProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    try {
      final userExiste = await _preferencias.tiene('user');
      if (userExiste) {
        user = User.fromJson(await _preferencias.leer('user'));
        _productosProvider.init(context, user!);
        // inspect(user);
        refresh();
      }
    } on Exception catch (e) {
      print(e);
      return;
    }
    // refresh();
  }

  Future<List<Producto>?> getMaterialesEmpresa(String idEmpresa) async {
    productos = await _productosProvider.getProductosPorEmpresa(idEmpresa);
    // print(usuarios);
    // inspect(productos);
    return productos;
  }
}
