import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/cliente/empresa/detalle/cliente_empresa_detalle_page.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteEmpresaController {
  late BuildContext context;
  late Function refresh;
  late Empresa empresa;
  User? user;

  final _preferencias = SharedPref();

  void init(BuildContext context, Function refresh, Empresa empresa) async {
    this.context = context;
    this.refresh = refresh;
    this.empresa = empresa;
    try {
      final userExiste = await _preferencias.tiene('user');
      if (userExiste) {
        user = User.fromJson(await _preferencias.leer('user'));
        // _empresaProvider.init(context, user!);
        // inspect(user);
      }
    } on Exception catch (e) {
      print(e);
      return;
    }
    // refresh();
  }

  void goToDetalleProductosPage(String id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ClienteEmpresaDetallePage(id: id)));
  }

  void goToAddressListPage(String id) {
    Navigator.pushNamed(context, 'cliente/address/list', arguments: id);
  }
}
