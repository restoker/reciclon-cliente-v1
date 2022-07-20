import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/detalle/encamino/recolector_orden_detalle_encamino_page.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class RecolectorOrdenDespachadoDetalleController {
  late BuildContext context;
  late Function refresh;
  User? user;
  late Orden orden;
  final _preferencias = SharedPref();
  final _ordenesProvider = OrdenesProvider();

  void init(BuildContext context, Function refresh, Orden orden) async {
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    user = User.fromJson(await _preferencias.leer('user'));
    _ordenesProvider.init(context, user);
    refresh();
  }

  void actualizarOrdenAEncamino() async {
    // if (orden == null) return;
    Map<String, String> ordenIds = {
      'id': orden.id.toString(),
      'id_recolector': user!.id.toString(),
    };

    Loading.show(context);

    ResponseApi? respuesta =
        await _ordenesProvider.actualizarOrdenToEnCamino(ordenIds);
    if (respuesta != null) {
      Navigator.pop(context);
      if (respuesta.success == true) {
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   'delivery/ordenes/detalle/map',
        //   (route) => false,
        //   arguments: orden.toJson(),
        // );

        Navigator.of(context).pushAndRemoveUntil<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => RecolectorOrdenDetalleEncaminoPage(
              orden: orden,
            ),
          ),
          (route) {
            return route.settings.name == 'recolector/home';
          },
        );
      } else {
        MySnackbar.show(
            context, 'No se pudo actualizar la orden, intentelo nuevamente');
      }
    } else {
      Navigator.pop(context);
      MySnackbar.show(context, 'Ocurrrio un error con el servidor');
    }
  }
}
