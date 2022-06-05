import 'package:flutter/material.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
// import 'package:reciclon_client/src/providers/push_notification_provider.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class LoginController {
  late BuildContext context;
  late Function refresh;
  bool isBlind = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final preferencias = SharedPref();
  final userProvider = UserProvider();
  // final _pushNotificationProvider = PushNotificationProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    bool usuarioExiste = await preferencias.tiene('user');
    if (usuarioExiste) {
      final user = User.fromJson(await preferencias.leer('user'));
      if (user.sessionToken != null) {
        // _pushNotificationProvider.saveToken(user, this.context);
        if (user.roles!.length > 1) {
          Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, user.roles![0].route, (route) => false);
        }
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamedAndRemoveUntil(context, 'registro', (route) => false);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    // valdiar el email
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (email.isEmpty) {
      MySnackbar.show(context, 'El Email es obligatorio 😸');
      return;
    }

    if (!emailValid) {
      MySnackbar.show(context, 'El Email ingresado no es valido 🙀');
      return;
    }

    if (password.isEmpty) {
      MySnackbar.show(context, 'El PAssword es obligatorio 😹');
      return;
    }

    if (password.length < 5) {
      MySnackbar.show(context, 'Su contraseña deberia de ser mas segura 🙀');
      return;
    }

    Loading.show(context);

    ResponseApi? respuesta = await userProvider.login(email, password);
    if (respuesta != null) {
      if (respuesta.success == true) {
        User usuario = User.fromJson(respuesta.data);
        preferencias.guardar('user', usuario.toJson());
        // inspect(usuario);
        if (usuario.roles!.length > 1) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        } else {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, usuario.roles![0].route, (route) => false);
        }
      } else {
        MySnackbar.show(context, respuesta.msg);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      MySnackbar.show(context, 'No tienen conexion a internet');
    }
  }

  void mostrarPassword() {
    isBlind = !isBlind;
    refresh();
  }
}
