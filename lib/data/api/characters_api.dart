import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';

class CharactersApi {
  Future<Map<String, dynamic>> getCharacters(String token,
      [String? url]) async {
    //Esta validación es importante para manejar el escenario;
    // - Primera vez que se manda a llamar al endpoint
    final uri = Uri.parse(url ?? 'https://rickandmortyapi.com/api/character');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      logger.i(
          '[CharactersApi] getCharacters() | Personajes obtenidos correctamente');
      //logger.d(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception(
          '[CharactersApi] getCharacters() | Error al obtener los personajes');
    }
  }
}
