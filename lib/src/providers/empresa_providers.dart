import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/empresa.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class EmpresaProviders {
  final _url = Enviroment.apiDelivery;
  final _api = '/api/empresas';

  late BuildContext context;
  User? sesionUser;

  void init(BuildContext context, User sesionUser) {
    this.context = context;
    this.sesionUser = sesionUser;
  }

  Future<Stream?> crearEmpresa(Empresa empresa, File? imagen) async {
    try {
      // final url = Uri.http(_url, '$_api/nueva');
      final url = Uri.https(_url, '$_api/nueva');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = sesionUser!.sessionToken!;
      if (imagen != null) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(imagen.openRead().cast()),
          await imagen.length(),
          filename: basename(imagen.path),
        ));
      }
      request.fields['empresa'] = json.encode(empresa);

      final response = await request.send();
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

  Future<List<Empresa>?> obtenerEmpresasAprobadas(String idUser) async {
    try {
      Uri url = Uri.https(_url, '$_api/getAllAproved/$idUser');
      // Uri url = Uri.http(_url, '$_api/getAllAproved/$idUser');
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 403) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      final data = json.decode(resp.body);
      // inspect(data);
      List<Empresa>? lista = Empresa.fromJsonList(data["data"]).toList;
      return lista;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Empresa>?> obtenerEmpresasPreAprobadas(String idUser) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/getAllNoAproved/$idUser');
      // Uri url = Uri.http(_url, '$_api/getAllNoAproved/$idUser');
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 403) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      final data = json.decode(resp.body);
      // inspect(data);
      List<Empresa>? lista = Empresa.fromJsonList(data["data"]).toList;
      return lista;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseApi?> actualizarEmpresaToAprobada(
      Map<String, String> dataUpdate) async {
    if (sesionUser == null) return null;
    try {
      // Uri url = Uri.http(_url, '$_api/actualizarEstado');
      Uri url = Uri.https(_url, '$_api/actualizarEstado');
      // Uri url = Uri.https(_url, '$_api/updateUserToDelivery');
      String bodyParams = json.encode(dataUpdate);
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.put(url, headers: headers, body: bodyParams);
      if (resp.statusCode == 403) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      final data = json.decode(resp.body);
      final respuestaApi = ResponseApi.fromJson(data);
      // inspect(respuestaApi);
      return respuestaApi;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Empresa>?> getEmpresasByCategorias(String categoria) async {
    if (sesionUser == null) return null;
    try {
      // Uri url = Uri.http(_url, '$_api/findEmpresasPorCategoria/$categoria');
      Uri url = Uri.https(_url, '$_api/findEmpresasPorCategoria/$categoria');
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
      // inspect(data);
      Empresa empresa = Empresa.fromJsonList(data["data"]);
      // inspect(orden);
      // inspect(respuestaApi);
      return empresa.toList;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }
}
