import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/detalle/despachado/recolector_orden_despachado_detalle_page.dart';
import 'package:reciclon_client/src/pages/recolector/ordenes/detalle/encamino/recolector_orden_detalle_encamino_page.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class RecolectorOrdenesListaController {
  late BuildContext context;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  User? user;
  late Function refresh;
  bool? isUpdated;
  final List<String> status = [
    "DESPACHADO",
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

  // void recivirOrden() {
  //   socket.on('despacharRecolector/${orden.id}', (data) {
  //     addMarkerToMap(
  //       'recolector',
  //       data['lat'],
  //       data['lng'],
  //       'El recolector',
  //       '',
  //       recolectorMarker,
  //     );
  //   });
  // }

  Future<List<Orden>> getOrdenes(String status) async {
    if (user != null) {
      List<Orden> ordenes = await _ordenesProvider
          .getOrdersOfDeliveryByStatusAndDeliveryId(status, user!.id!);
      // inspect(ordenes);
      return ordenes;
    } else {
      return [];
    }
  }

  void goToDetalleOrdenPage(Orden orden) async {
    // validar el status de la orden
    if (orden.status == 'DESPACHADO') {
      isUpdated = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => RecolectorOrdenDespachadoDetallePage(orden: orden),
        ),
      );
    } else if (orden.status == 'EN CAMINO') {
      // isUpdated = await Navigator.of(context).push<bool>(
      //   MaterialPageRoute<bool>(
      //     builder: (_) => DeliveryOrdenesDetalleMapPage(),
      //   ),
      // );
      isUpdated = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => RecolectorOrdenDetalleEncaminoPage(orden: orden),
          settings: RouteSettings(
            name: 'recolector/orden/detalle/encamino',
          ),
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
  }

  void goToRoles(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToEditProfile() {
    Navigator.pushNamed(context, 'cliente/update');
  }
}
