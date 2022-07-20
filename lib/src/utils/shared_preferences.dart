import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:reciclon_client/src/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> guardar(String key, value) async {
    final preferencias = await SharedPreferences.getInstance();
    preferencias.setString(key, json.encode(value));
  }

  Future<dynamic> leer(String key) async {
    final preferencias = await SharedPreferences.getInstance();
    if (preferencias.getString(key) != null) {
      return json.decode(preferencias.getString(key)!);
    } else {
      return null;
    }
  }

  Future<bool> tiene(String key) async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.containsKey(key);
  }

  Future<bool> eliminar(String key) async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.remove(key);
  }

  void logout(BuildContext context, String idUser) async {
    final userProvider = UserProvider();
    await userProvider.init(context);
    // await userProvider.logOut(idUser);
    await eliminar('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
