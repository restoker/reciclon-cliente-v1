import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:reciclon_client/src/models/address.dart' as address;
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/orden_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';

class ClienteStripeCrearController {
  Map<String, dynamic>? paymentIntentData;
  final _ordenProvider = OrdenesProvider();
  // final _preferencias = SharedPref();

  Future<void> makePayment(BuildContext context, address.Address direccion,
      String? idEmpresa, User? user) async {
    try {
      paymentIntentData = await createPaymentIntent('15', 'USD');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                applePay: true,
                googlePay: true,
                testEnv: true,
                style: ThemeMode.dark,
                merchantCountryCode: 'US',
                merchantDisplayName: 'Milthon'),
          )
          .then((value) {});
      showPaymentSheet(context, direccion, idEmpresa, user);
    } catch (e) {
      print(e);
    }
  }

  showPaymentSheet(BuildContext context, address.Address direccion,
      String? idEmpresa, User? user) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        MySnackbar.show(context, 'Transaccion exitosa', isSuccess: true);
        paymentIntentData = null;

        Loading.show(context);

        final orden = Orden(
          idUser: user!.id!,
          idDireccion: direccion.id!,
          idEmpresa: idEmpresa!,
          lat: direccion.lat,
          lng: direccion.lng,
        );

        ResponseApi? respuesta = await _ordenProvider.crear(orden);
        if (respuesta != null) {
          Navigator.pop(context);
          if (respuesta.success == true) {
            MySnackbar.show(context, respuesta.msg, isSuccess: true);
            // Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, 'cliente/home', (route) => false);
          } else {
            MySnackbar.show(context, 'No se pudo crear la dirección');
          }
        }
      }).onError((error, stackTrace) {
        print('Error en transacción $error - $stackTrace');
      });
    } on StripeException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (value) => AlertDialog(
          content: Text('Operación cancelada'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calcularAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer "poner aca la clave secreta"',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return json.decode(response.body);
    } on Exception catch (e) {
      print(e);
    }
  }

  String calcularAmount(String amount) {
    final cantidad = int.parse(amount) * 100;
    return cantidad.toString();
  }
}
