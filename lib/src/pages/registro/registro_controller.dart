import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/push_notification_provider.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class RegistroController {
  late BuildContext context;
  late Function refresh;
  XFile? pickedFile;
  File? imageFile;
  bool isEnable = true;
  bool isBlind = true;
  bool isBlindConfirm = true;

  final emailController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarController = TextEditingController();
  final _pushNotificationProvider = PushNotificationProvider();

  final preferencias = SharedPref();
  final userProvider = UserProvider();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  void goToLoginPage() {
    Navigator.pop(context);
  }

  void mostrarPassword() {
    isBlind = !isBlind;
    refresh();
  }

  void mostrarConfirmar() {
    isBlindConfirm = !isBlindConfirm;
    refresh();
  }

  Future<void> selectImage(ImageSource imageSource) async {
    // print(imageSource);
    pickedFile = await ImagePicker().pickImage(
      source: imageSource,
      maxHeight: 350,
      maxWidth: 350,
      imageQuality: 65,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void registro() async {
    String email = emailController.text.trim().toLowerCase();
    String nombre = nombreController.text.trim().toLowerCase();
    String apellido = apellidoController.text.trim().toLowerCase();
    String telefono = telefonoController.text.trim();
    String password = passwordController.text.trim();
    String confirmar = confirmarController.text.trim();
    String? token = await FirebaseMessaging.instance.getToken();

    if (email.isEmpty ||
        nombre.isEmpty ||
        apellido.isEmpty ||
        telefono.isEmpty ||
        password.isEmpty ||
        confirmar.isEmpty) {
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmar != password) {
      MySnackbar.show(context, 'Las contraseñas deben de ser iguales');
      return;
    }

    if (imageFile == null) {
      MySnackbar.show(context, 'Seleccione una imagen, para su perfil');
      return;
    }

    if (token == null) {
      MySnackbar.show(context, 'No se pudo generar su token');
      return;
    }

    Loading.show(context);

    final usuario = User(
      nombre: nombre,
      apellidos: apellido,
      email: email,
      telefono: telefono,
      password: password,
      notificationToken: token,
    );

    // inspect(usuario);
    print(usuario.notificationToken);

    Stream? stream =
        await userProvider.crearUsuarioConImagen(usuario, imageFile);
    if (stream != null) {
      stream.listen((res) async {
        ResponseApi? respuesta = ResponseApi.fromJson(json.decode(res));
        if (respuesta.success == true) {
          // inspect(respuesta.data);
          User usuario = User.fromJson(respuesta.data);
          // inspect(usuario);
          await preferencias.guardar('user', usuario.toJson());
          Navigator.pop(context);
          MySnackbar.show(context, respuesta.msg, isSuccess: true);
          Navigator.pushNamedAndRemoveUntil(
              context, 'cliente/home', (route) => false);
        } else {
          Navigator.pop(context);
          MySnackbar.show(context, respuesta.msg);
          // Navigator.pop(context);
        }
      });
    } else {
      MySnackbar.show(context, 'No se pudo Registrar al usuario');
      Navigator.pop(context);
    }

    isEnable = false;
  }
}
