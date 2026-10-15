import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../general/config/config.dart';

// Error que lanzamos cuando el servidor responde con un error.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

// Cliente HTTP pequeno: agrega el token y convierte errores en ApiException.
class ApiClient {
  // Nombre con el que guardamos el idToken de Firebase en shared_preferences.
  static const tokenKey = 'token';

  // Se ejecuta cuando el servidor responde 401 (el token vencio, dura 1 hora).
  // main.dart lo usa para mandar al usuario al login.
  static void Function()? onUnauthorized;

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  Future<dynamic> get(String path) async {
    http.Response response;
    try {
      response = await http.get(_uri(path), headers: await _headers());
    } catch (e) {
      throw ApiException('Connection error. Check internet');
    }
    return _check(path, response);
  }

  Future<dynamic> post(String path, Object? body) async {
    http.Response response;
    try {
      response = await http.post(_uri(path), headers: await _headers(), body: jsonEncode(body));
    } catch (e) {
      throw ApiException('Connection error. Check internet');
    }
    return _check(path, response);
  }

  Future<dynamic> put(String path, Object? body) async {
    http.Response response;
    try {
      response = await http.put(_uri(path), headers: await _headers(), body: jsonEncode(body));
    } catch (e) {
      throw ApiException('Connection error. Check internet');
    }
    return _check(path, response);
  }

  // Revisa la respuesta: si es 2xx devuelve el JSON; si no, lanza ApiException.
  Future<dynamic> _check(String path, http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null; // ej. 204 sin contenido
      return jsonDecode(response.body);
    }

    // 401 en una pantalla protegida = el token ya no sirve: lo borramos y vamos al login.
    // En /api/auth (login, registro) un 401 solo significa "contrasena incorrecta".
    if (response.statusCode == 401 && !path.startsWith('/api/auth')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      onUnauthorized?.call();
    }

    throw ApiException(_leerMensaje(response), response.statusCode);
  }

  // Lee el mensaje de error (ProblemDetails): "detail" o el mapa "errors".
  String _leerMensaje(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data['errors'] != null) {
        final lista = <String>[];
        for (final mensajes in (data['errors'] as Map).values) {
          lista.addAll(List<String>.from(mensajes));
        }
        if (lista.isNotEmpty) return lista.join('\n');
      }
      if (data['detail'] != null) return data['detail'];
      if (data['title'] != null) return data['title'];
    } catch (e) {
      throw ApiException(e.toString());
    }
    return 'Something went wrong';
  }
}
