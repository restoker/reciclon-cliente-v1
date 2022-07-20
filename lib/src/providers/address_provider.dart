import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/address.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class AddressProvider {
  final _url = Enviroment.apiDelivery;
  final _api = '/api/address';
  User? sesionUser;

  late BuildContext context;

  Future init(BuildContext context, User? sesionUser) async {
    this.context = context;
    this.sesionUser = sesionUser;
  }

  Future<ResponseApi?> create(Address direccion) async {
    if (sesionUser == null) return null;
    inspect(direccion);
    try {
      Uri url = Uri.https(_url, '$_api/nueva');
      // Uri url = Uri.http(_url, '$_api/nueva');
      String bodyParams = json.encode(direccion);
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.post(url, headers: headers, body: bodyParams);
      // final resp = await http.post(url, headers: headers, body: bodyParams);
      if (resp.statusCode == 403) {
        //no autorizado
        Fluttertoast.showToast(msg: 'Su sesión expiro');
        SharedPref().logout(context, sesionUser!.id!);
      }
      final data = json.decode(resp.body);
      // inspect(data);
      final respuestaApi = ResponseApi.fromJson(data);
      // inspect(respuestaApi);
      return respuestaApi;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Address>> getAddress(String userId) async {
    if (sesionUser == null) return [];
    try {
      Uri url = Uri.https(_url, '$_api/$userId');
      // Uri url = Uri.http(_url, '$_api/$userId');
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
      Address address = Address.fromJsonToList(data['data']);
      return address.toList!;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }
}
