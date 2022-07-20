import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/orden.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class OrdenesProvider {
  final _url = Enviroment.apiDelivery;
  final _api = '/api/ordenes';
  User? sesionUser;

  late BuildContext context;

  Future<void> init(BuildContext context, User? sesionUser) async {
    this.context = context;
    this.sesionUser = sesionUser;
  }

  Future<ResponseApi?> crear(Orden orden) async {
    if (sesionUser == null) return null;
    // inspect(orden);
    try {
      Uri url = Uri.https(_url, '$_api/nueva');
      // Uri url = Uri.http(_url, '$_api/nueva');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.post(url, headers: headers, body: bodyParams);
      if (resp.statusCode == 401) {
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

  Future<List<Orden>> getOrdersOfClientByStatus(
      String status, String idCliente) async {
    if (sesionUser == null) return [];
    try {
      Uri url = Uri.https(_url, '$_api/findClienteOrdernes/$idCliente/$status');
      // Uri url = Uri.http(_url, '$_api/findClienteOrdernes/$idCliente/$status');
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
      Orden? orden = Orden.fromJsonList(data["data"]);
      // inspect(orden.toList);
      // inspect(respuestaApi);
      return orden.toList;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Orden>> getCategoriasByStatus(String status) async {
    if (sesionUser == null) return [];
    try {
      Uri url = Uri.https(_url, '$_api/findOrdenes/$status');
      // Uri url = Uri.http(_url, '$_api/findOrdenes/$status');
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
      Orden orden = Orden.fromJsonList(data["data"]);
      // inspect(orden);
      // inspect(respuestaApi);
      return orden.toList;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<User>?> getdeliveryUsers() async {
    // print(id);
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/findRepartidores');
      // Uri url = Uri.http(_url, '$_api/findRepartidores');
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
      // inspect(data['data']);
      final deliveryUser = User.fromJsonList(data['data']);
      // inspect(deliveryUser);
      return deliveryUser.toList;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<ResponseApi?> actualizarOrdenToDespachado(
      Map<String, String> orden) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/actualizarADespachado');
      // Uri url = Uri.http(_url, '$_api/actualizarADespachado');
      String bodyParams = json.encode(orden);
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

  // TODO
  Future<ResponseApi?> actualizarOrdenToEnCamino(
      Map<String, String> orden) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/actualizarAEnCamino');
      // Uri url = Uri.http(_url, '$_api/actualizarAEnCamino');
      String bodyParams = json.encode(orden);
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

  // TODO
  Future<ResponseApi?> actualizarOrdenToEntregado(
      Map<String, String> orden) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/actualizarAEntregado');
      // Uri url = Uri.http(_url, '$_api/actualizarAEntregado');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.put(url, headers: headers, body: bodyParams);
      inspect(resp);
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

  Future<ResponseApi?> actualizarLatLngDelivery(
      Map<String, dynamic> orden) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/updateLatLngDelivery');
      // Uri url = Uri.http(_url, '$_api/updateLatLngDelivery');
      String bodyParams = json.encode(orden);
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

  Future<List<Orden>> getOrdersOfDeliveryByStatusAndDeliveryId(
      String status, String idRecolector) async {
    if (sesionUser == null) return [];
    try {
      Uri url =
          Uri.https(_url, '$_api/findDeliveryOrdernes/$idRecolector/$status');
      // Uri url =
      //     Uri.http(_url, '$_api/findDeliveryOrdernes/$idRecolector/$status');
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
      Orden orden = Orden.fromJsonList(data["data"]);
      // inspect(orden);
      // inspect(respuestaApi);
      return orden.toList;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }
}
