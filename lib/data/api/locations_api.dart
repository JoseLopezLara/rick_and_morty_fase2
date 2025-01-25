import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';

class LocationsApi {
  Future<Map<String, dynamic>> getLocations(String token, [String? url]) async {
    final uri = Uri.parse(url ?? 'https://rickandmortyapi.com/api/location');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      logger.i('[LocationsApi] getLocations() | Ubicaciones obtenidas correctamente');
      return jsonDecode(response.body);
    } else {
      throw Exception('[LocationsApi] getLocations() | Error al obtener las ubicaciones');
    }
  }

  Future<Map<String, dynamic>> getLocation(String token, String locationId) async {
    final uri = Uri.parse('https://rickandmortyapi.com/api/location/$locationId');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      logger.i('[LocationsApi] getLocation() | Ubicación obtenida correctamente');
      return jsonDecode(response.body);
    } else {
      throw Exception('[LocationsApi] getLocation() | Error al obtener la ubicación');
    }
  }

  Future<Map<String, dynamic>> searchLocations(String token, String name) async {
    final uri = Uri.parse('https://rickandmortyapi.com/api/location/?name=$name');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.ok) {
      logger.i('[LocationsApi] searchLocations() | Búsqueda realizada correctamente');
      return jsonDecode(response.body);
    } else {
      throw Exception('[LocationsApi] searchLocations() | Error en la búsqueda');
    }
  }
}