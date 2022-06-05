import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciclon_client/src/models/producto.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/providers/productos_provider.dart';
import 'package:reciclon_client/src/utils/loading.dart';
import 'package:reciclon_client/src/utils/my_snackbar.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class EmpresaProductosCrearController {
  late BuildContext context;
  late Function refresh;
  late User user;
  XFile? pickedFile;
  File? imagen1;
  File? imagen2;
  File? imagen3;

  List<Map<String, dynamic>> categorias = [
    {'id': '1', 'nombre': 'PLASTICO'},
    {'id': '2', 'nombre': 'METALES'},
    {'id': '3', 'nombre': 'VIDRIOS'},
    {'id': '4', 'nombre': 'ORGANICOS'},
    {'id': '5', 'nombre': 'PAPEL'},
  ];

  String? idCategoria;

  final _preferencias = SharedPref();
  final _productoProvider = ProductosProvider();

  TextEditingController nombreMaterial = TextEditingController();
  TextEditingController descripcionMaterial = TextEditingController();
  MoneyMaskedTextController precioMaterial = MoneyMaskedTextController();

  void init(context, refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _preferencias.leer('user'));
    inspect(user);
    _productoProvider.init(context, user);
  }

  Future<void> selectImage(ImageSource imageSource, int numberFile) async {
    // print(imageSource);
    pickedFile = await ImagePicker().pickImage(
      source: imageSource,
      maxHeight: 350,
      maxWidth: 350,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      if (numberFile == 1) {
        imagen1 = File(pickedFile!.path);
      } else if (numberFile == 2) {
        imagen2 = File(pickedFile!.path);
      } else if (numberFile == 3) {
        imagen3 = File(pickedFile!.path);
      }
      Navigator.pop(context);
      refresh();
    }
  }

  void crearMaterial() async {
    final nombre = nombreMaterial.text.trim();
    final descripcion = descripcionMaterial.text.trim();
    final precio = precioMaterial.numberValue;

    // inspect(categoriasSeleccionadas);
    if (nombre.isEmpty || descripcion.isEmpty || precio == 0) {
      MySnackbar.show(context, 'Todos los campos son obligatorios');
      return;
    }

    if (imagen1 == null) {
      MySnackbar.show(context, 'Seleccione una imagen, para su empresa');
      return;
    }
    if (imagen2 == null || imagen3 == null || idCategoria == null) {
      MySnackbar.show(context, 'Seleccione una imagen, para su empresa');
      return;
    }

    final producto = Producto(
      nombre: nombre,
      descripcion: descripcion,
      precio: precio,
      idCategoria: int.parse(idCategoria!),
      idEmpresa: int.parse(user.empresa!.id!),
    );

    Loading.show(context);
    List<File?> imagenes = [];

    imagenes.add(imagen1);
    imagenes.add(imagen2);
    imagenes.add(imagen3);

    // inspect(producto);
    // inspect(imagenes);

    Stream? stream = await _productoProvider.crearProducto(producto, imagenes);

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

  void resetValues() {
    nombreMaterial.text = '';
    descripcionMaterial.text = '';
    precioMaterial.text = '0.0';
    imagen1 = null;
    imagen2 = null;
    imagen3 = null;
    idCategoria = null;
    refresh();
  }
}
