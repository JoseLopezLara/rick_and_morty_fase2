import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '/data/models/episode.dart';

final Logger logger = Logger();

class EpisodeApi {
  final String baseUrl = 'https://rickandmortyapi.com/api';

  // Método para obtener episodios paginados con manejo de errores
  Future<List<Episode>> fetchEpisodes({int page = 1, String? query}) async {
    try {
      String url = '$baseUrl/episode?page=$page';
      if (query != null && query.isNotEmpty) {
        url += '&name=$query';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Episode.fromJson(json)).toList();
      } else {
        logger.e(
            'Error ${response.statusCode}: No se pudieron obtener los episodios.');
        throw Exception(
            'Error ${response.statusCode}: No se pudieron obtener los episodios.');
      }
    } catch (e, stacktrace) {
      logger.e('Error en fetchEpisodes(): $e',
          error: e, stackTrace: stacktrace);
      throw Exception('Error al obtener episodios: $e');
    }
  }

  // Método para obtener un episodio por URL con manejo de errores
  Future<Episode> fetchEpisodeByUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Episode.fromJson(data);
      } else {
        logger
            .e('Error ${response.statusCode}: No se pudo obtener el episodio.');
        throw Exception(
            'Error ${response.statusCode}: No se pudo obtener el episodio.');
      }
    } catch (e, stacktrace) {
      logger.e('Error en fetchEpisodeByUrl(): $e',
          error: e, stackTrace: stacktrace);
      throw Exception('Error al obtener el episodio desde $url: $e');
    }
  }
}
