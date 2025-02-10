import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '/data/models/episode.dart';

final Logger logger = Logger();

class EpisodeRepository {
  final String baseUrl;

  EpisodeRepository({required this.baseUrl});

  // Método para obtener episodios con paginación y búsqueda
  Future<List<Episode>> getEpisodes({int page = 1, String? query}) async {
    try {
      String url = '$baseUrl/episode?page=$page';
      if (query != null && query.isNotEmpty) {
        url += '&name=$query';
      }

      logger.i('Fetching episodes from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        logger.i('Episodes fetched successfully. Total: ${results.length}');
        return results.map((json) => Episode.fromJson(json)).toList();
      } else {
        logger
            .e('Failed to fetch episodes. Status code: ${response.statusCode}');
        throw Exception('Failed to load episodes');
      }
    } catch (e, stacktrace) {
      logger.e('Error while fetching episodes',
          error: e, stackTrace: stacktrace);
      throw Exception('Error while fetching episodes: $e');
    }
  }

  // Método para obtener un episodio específico por URL
  Future<Episode> fetchEpisodeByUrl(String url) async {
    try {
      logger.i('Fetching episode from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logger.i('Episode fetched successfully from: $url');
        return Episode.fromJson(data);
      } else {
        logger
            .e('Failed to fetch episode. Status code: ${response.statusCode}');
        throw Exception('Failed to load episode from $url');
      }
    } catch (e, stacktrace) {
      logger.e('Error while fetching episode from $url',
          error: e, stackTrace: stacktrace);
      throw Exception('Error while fetching episode from $url: $e');
    }
  }
}
