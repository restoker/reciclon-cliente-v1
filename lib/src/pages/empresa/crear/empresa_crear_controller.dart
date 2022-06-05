import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/empresa_providers.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class EmpresaCrearController {
  late BuildContext context;
  late Function refresh;
  late User user;
  XFile? pickedFile;
  File? imageFile;
  List<String> categoriasExistentes = [
    'VIDRIOS',
    'METALES',
    'ORGANICOS',
    'PLASTICOS',
    'PAPEL'
  ];
  // List<Map<String, dynamic>> categorias = [
  //   {'id': 1, 'nombre': 'PLASTICO'},
  //   {'id': 2, 'nombre': 'METALES'},
  //   {'id': 3, 'nombre': 'VIDRIOS'},
  //   {'id': 4, 'nombre': 'ORGANICOS'},
  //   {'id': 5, 'nombre': 'PAPEL'},
  // ];
  List<dynamic> categoriasSeleccionadas = [];
  List<String> categoriasEmpresa = [];

  final _preferencias = SharedPref();
  final _empresaProvider = EmpresaProviders();

  TextEditingController nombreEmpresa = TextEditingController();
  TextEditingController descripcionEmpresa = TextEditingController();
  TextEditingController razonSocialEmpresa = TextEditingController();
  TextEditingController telefonoEmpresa = TextEditingController();
  TextEditingController direccionEmpresa = TextEditingController();
  TextEditingController emailEmpresa = TextEditingController();

  void init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    bool usuarioExiste = await _preferencias.tiene('user');
    if (usuarioExiste) {
      user = User.fromJson(await _preferencias.leer('user'));
      _empresaProvider.init(context, user);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
    // await categoriProvider.init(context, user);
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

  void resetValues() {
    nombreEmpresa.text = '';
    descripcionEmpresa.text = '';
    razonSocialEmpresa.text = '';
    telefonoEmpresa.text = '';
    emailEmpresa.text = '';
    direccionEmpresa.text = '';
    imageFile = null;
    refresh();
  }

  void crearEmpresa() async {
    final nombre = nombreEmpresa.text.trim();
    final descripcion = descripcionEmpresa.text.trim();
    final razonSocial = razonSocialEmpresa.text.trim();
    final telefono = telefonoEmpresa.text.trim();
    final direccion = direccionEmpresa.text.trim();
    final email = emailEmpresa.text.trim();
    categoriasEmpresa = List<String>.from(categoriasSeleccionadas);

    // inspect(categoriasSeleccionadas);
    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        razonSocial.isEmpty ||
        telefono.isEmpty ||
        direccion.isEmpty ||
        email.isEmpty) {
      MySnackbar.show(context, 'Todos los campos son obligatorios');
      return;
    }

    if (imageFile == null) {
      MySnackbar.show(context, 'Seleccione una imagen, para su empresa');
      return;
    }

    if (categoriasEmpresa.isEmpty) {
      MySnackbar.show(context, 'Seleccione una categoria, para su empresa');
      return;
    }

    Loading.show(context);
    final empresa = Empresa(
      idUser: user.id!,
      nombre: nombre,
      razonSocial: razonSocial,
      telefono: telefono,
      direccion: direccion,
      email: email,
      descripcion: descripcion,
      categorias: categoriasEmpresa,
    );

    Stream? stream = await _empresaProvider.crearEmpresa(empresa, imageFile);
    if (stream != null) {
      stream.listen((res) async {
        ResponseApi? respuesta = ResponseApi.fromJson(json.decode(res));
        if (respuesta.success == true) {
          resetValues();
          Navigator.pop(context);
          MySnackbar.show(context, respuesta.msg, isSuccess: true);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, 'cliente/home', (route) => false);
        } else {
          Navigator.pop(context);
          MySnackbar.show(context, respuesta.msg);
          // Navigator.pop(context);
        }
      });
    } else {
      MySnackbar.show(context, 'No se pudo Registrar la empresa');
      Navigator.pop(context);
    }
  }
}
