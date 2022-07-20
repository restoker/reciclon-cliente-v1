import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reciclon_client/src/api/enviroment.dart';
import 'package:reciclon_client/src/models/response_api.dart';
import 'package:reciclon_client/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:reciclon_client/src/utils/shared_preferences.dart';

class UserProvider {
  final _url = Enviroment.apiDelivery;
  final _api = '/api/users';

  late BuildContext context;
  User? sesionUser;

  Future init(BuildContext context, {User? sesionUser}) async {
    this.context = context;
    this.sesionUser = sesionUser;
  }

  Future<Stream?> crearUsuarioConImagen(User user, File? imagen) async {
    try {
      final url = Uri.https(_url, '$_api/nuevo');
      // final url = Uri.http(_url, '$_api/nuevo');
      final request = http.MultipartRequest('POST', url);
      if (imagen != null) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(imagen.openRead().cast()),
          await imagen.length(),
          filename: basename(imagen.path),
        ));
      }
      request.fields['user'] = json.encode(user);
      final response = await request.send();
      return response.stream.transform(utf8.decoder);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<Stream?> crearUsuarioConImagenDio(User user, File? imagen) async {
    // referencia: https://stackoverflow.com/questions/49125191/how-to-upload-images-and-file-to-a-server-in-flutter

    try {
      // final url = Uri.http(_url, '$_api/nuevoUsuario');
      // final request = http.MultipartRequest('POST', url);
      final dioRequest = dio.Dio();
      dioRequest.options.baseUrl = 'http://$_api/nuevoUsuario';

      final formData = dio.FormData.fromMap({'user': json.encode(user)});

      if (imagen != null) {
        // request.files.add(http.MultipartFile(
        //   'image',
        //   http.ByteStream(imagen.openRead().cast()),
        //   await imagen.length(),
        //   filename: basename(imagen.path),
        // ));
        final file = await dio.MultipartFile.fromFile(imagen.path,
            filename: basename(imagen.path),
            contentType: MediaType("image", basename(imagen.path)));

        formData.files.add(MapEntry('imagen', file));
      }

      final response = await dioRequest.post(
        'http://$_api/nuevoUsuario',
        data: formData,
      );

      final result = json.decode(response.toString());
      // inspect(result);

      // request.fields['user'] = json.encode(user);
      // final formData =

      // final response = await request.send();

      // return response.stream.transform(utf8.decoder);

    } on Exception catch (e) {
      print(e);
    }
  }

  Future<ResponseApi?> login(String email, String password) async {
    try {
      Uri url = Uri.https(_url, '$_api/login');
      // Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({'email': email, 'password': password});
      Map<String, String> headers = {
        'Content-type': "application/json",
      };
      final resp = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(resp.body);
      final respuestaApi = ResponseApi.fromJson(data);
      return respuestaApi;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<Stream?> actualizarUsuarioConImagen(User user, File? imagen) async {
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/update');
      // Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = sesionUser!.sessionToken!;
      if (imagen != null) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(imagen.openRead().cast()),
          await imagen.length(),
          filename: basename(imagen.path),
        ));
      }
      // aqui se especifica el campo user para el req.body.user
      request.fields['user'] = json.encode(user);
      final response = await request.send(); // enviar la peticion
      if (response.statusCode == 403) {
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

  Future<List<User>?> getUsersNoDelivery() async {
    // print('me ejecute');
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/usersNoDelivery');
      // Uri url = Uri.http(_url, '$_api/usersNoDelivery');
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

  Future<ResponseApi?> actualizarUsuarioToDelivery(
      Map<String, String> usuario) async {
    if (sesionUser == null) return null;
    try {
      // Uri url = Uri.http(_url, '$_api/updateUserToDelivery');
      Uri url = Uri.https(_url, '$_api/updateUserToDelivery');
      String bodyParams = json.encode(usuario);
      Map<String, String> headers = {
        'Content-type': "application/json",
        "Authorization": sesionUser!.sessionToken!
      };
      final resp = await http.post(url, headers: headers, body: bodyParams);
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

  Future<ResponseApi?> updateNotificationToken(
      String idUser, String token) async {
    if (sesionUser == null) return null;
    try {
      // Uri url = Uri.http(_url, '$_api/updateNotification');
      Uri url = Uri.https(_url, '$_api/updateNotification');
      String bodyParams = json.encode({
        'id': idUser,
        'notification_token': token,
      });
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
      return respuestaApi;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> getById(String? id) async {
    // print(id);
    if (sesionUser == null) return null;
    try {
      Uri url = Uri.https(_url, '$_api/findByid/$id');
      // Uri url = Uri.http(_url, '$_api/findByid/$id');
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
      User user = User.fromJson(data['data']);
      // inspect(user);
      return user;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }
}

// elastic drawer
// https://www.youtube.com/watch?v=1KurAaGLwHc
