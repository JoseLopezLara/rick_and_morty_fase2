import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<Map<String, dynamic>> login(String body) async {
    const url = 'https://dummyjson.com/auth/login';
    final uri = Uri.parse(url);

    // Create a POST request
    try {
      final response = await http.post(uri, body: body, headers: {
        'Content-Type': 'application/json',
      });

      final statusCode = response.statusCode;
      // Analizar que el código de estado sea 2xx (OK)
      if (statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      }

      throw Exception('Error en la petición: ${response.statusCode}');

    } catch (error) {
      throw Exception('Solisitud sin respuesta: $error');
    }
  }
}
