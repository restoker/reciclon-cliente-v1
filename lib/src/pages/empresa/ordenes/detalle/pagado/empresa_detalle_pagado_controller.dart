import 'package:flutter/material.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/providers/push_notification_provider.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class EmpresaDetallePagadoController {
  late BuildContext context;
  late Function refresh;
  User? user;
  late Orden orden;
  List<User> repartidores = [];
  String? idRepartidor;
  late IO.Socket socket;

  final _preferencias = SharedPref();
  final _ordenesProvider = OrdenesProvider();
  final _userProvider = UserProvider();
  final _pushNotificationProvider = PushNotificationProvider();

  void init(BuildContext context, Function refresh, Orden orden) async {
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    user = User.fromJson(await _preferencias.leer('user'));
    _userProvider.init(context, sesionUser: user);
    _ordenesProvider.init(context, user);
    socket = IO.io('http://${Enviroment.apiDelivery}/ordenes/recolector',
        IO.OptionBuilder().setTransports(['websocket']).build());
    obtenerRepartidores();
    refresh();
  }

  void sendNotificationToDelivery(String tokenDelivery) {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};
    _pushNotificationProvider.sendMessage(
      tokenDelivery,
      data,
      'RECOJO ASIGNADO',
      'Te han asignado un recojo',
    );
  }

  void emitirOrdenDespachada() {
    socket.emit('despacharRecolector', {
      'id_order': orden.id,
      'id_recolector': idRepartidor,
    });
  }

  void dispose() {
    socket.disconnect();
  }

  Future<List<User>?> obtenerRepartidores() async {
    final resultado = await _ordenesProvider.getdeliveryUsers();
    if (resultado == null) {
      repartidores = [];
    } else {
      // inspect(resultado);
      repartidores = resultado;
    }
    refresh();
  }

  void actualizarOrdenADespachado() async {
    if (repartidores.isNotEmpty && idRepartidor != null) {
      // User repartidor = repartidores[int.parse(idRepartidor.toString()) - 1];
      Map<String, String> ordenIds = {
        'id': orden.id.toString(),
        'id_recolector': idRepartidor!,
      };

      Loading.show(context);

      ResponseApi? respuesta =
          await _ordenesProvider.actualizarOrdenToDespachado(ordenIds);
      if (respuesta != null) {
        User? deliveryUser = await _userProvider.getById(idRepartidor);
        if (deliveryUser != null) {
          sendNotificationToDelivery(deliveryUser.notificationToken!);
        }
        Navigator.pop(context);
        if (respuesta.success == true) {
          emitirOrdenDespachada();
          Navigator.pop(context, true);
        }
      } else {
        Navigator.pop(context);
        MySnackbar.show(
            context, 'No se pudo actualizar la orden, intentelo mas tarde');
      }
    }
  }
}
