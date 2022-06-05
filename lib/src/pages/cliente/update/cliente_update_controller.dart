import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class ClienteUpdateController {
  late BuildContext context;
  XFile? pickedFile;
  File? imageFile;
  late Function refresh;
  bool isEnable = true;
  User? user;

  final _preferencias = SharedPref();
  final _userProvider = UserProvider();

  TextEditingController emailController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    final existeUser = await _preferencias.tiene('user');
    if (existeUser) {
      user = User.fromJson(await _preferencias.leer('user'));
      await _userProvider.init(context, sesionUser: user);
      emailController.text = user!.email;
      nombreController.text = user!.nombre;
      apellidoController.text = user!.apellidos;
      telefonoController.text = user!.telefono;
      refresh();
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  void goToLoginPage() {
    Navigator.pushReplacementNamed(context, 'login');
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

  void update(BuildContext context) async {
    String email = emailController.text.trim().toLowerCase();
    String nombre = nombreController.text.trim().toLowerCase();
    String apellido = apellidoController.text.trim().toLowerCase();
    String telefono = telefonoController.text.trim();

    if (email.isEmpty ||
        nombre.isEmpty ||
        apellido.isEmpty ||
        telefono.isEmpty) {
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    if (telefono.length != 9) {
      MySnackbar.show(context, 'El teléfono debe tener 9 dígitos');
      return;
    }

    if (!email.contains('@')) {
      MySnackbar.show(context, 'El Email no es valido');
      return;
    }
    // if (imageFile == null) {
    //   MySnackbar.show(context, 'Seleccione una imagen, para su perfil');
    //   return;
    // }

    isEnable = false;
    // spinner de carga
    Loading.show(context);

    User usuario = User(
      id: user!.id,
      email: email,
      apellidos: apellido,
      nombre: nombre,
      telefono: telefono,
      imagen: user!.imagen,
    );

    try {
      final stream =
          await _userProvider.actualizarUsuarioConImagen(usuario, imageFile);
    } on Exception catch (e) {
      print(e);
    }

    isEnable = true;
  }
}
