import 'dart:convert';
// import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/producto.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:reciclon_client/src/utils/shared_preferences.dart';
import 'package:path/path.dart';

class ProductosProvider {
  final _url = Enviroment.apiDelivery;
  final _api = '/api/productos';

  late BuildContext context;
  User? sesionUser;

  void init(BuildContext context, User sesionUser) {
    this.context = context;
    this.sesionUser = sesionUser;
  }

  Future<Stream?> crearProducto(Producto producto, List<File?> imagenes) async {
    if (sesionUser == null) return null;
    try {
      // Uri url = Uri.http(_url, '$_api/nuevo');
      Uri url = Uri.https(_url, '$_api/nuevo');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = sesionUser!.sessionToken!;

      for (var i = 0; i < imagenes.length; i++) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(imagenes[i]!.openRead().cast()),
          await imagenes[i]!.length(),
          filename: basename(imagenes[i]!.path),
        ));
      }

      // aqui se especifica el campo user para el req.body.user
      request.fields['producto'] = json.encode(producto);
      // request.headers;
      final response = await request.send(); // enviar la peticion
      if (response.statusCode == 401) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      return response.stream.transform(utf8.decoder);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Producto>?> getProductosPorEmpresa(String idEmpresa) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/getProductos/$idEmpresa');
      // Uri url = Uri.http(_url, '$_api/getProductos/$idEmpresa');
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 401) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      final data = json.decode(resp.body);
      // inspect(data['data']);
      Producto producto = Producto.fromJsonList(data["data"]);
      // inspect(producto.toList);
      return producto.toList;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
