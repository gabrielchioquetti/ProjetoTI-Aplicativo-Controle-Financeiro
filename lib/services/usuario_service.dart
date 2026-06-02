import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {
  static const String baseUrl = "http://localhost:8080";

  static Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuarios"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nome": nome,
        "email": email,
        "senha": senha,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> login({
    required String email,
    required String senha,
  }) async {

    final response = await http.post(
      Uri.parse("$baseUrl/usuarios/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    return response.statusCode == 200;
  }
}