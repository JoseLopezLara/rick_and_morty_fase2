// lib/data/api/episode_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/episode.dart';

class EpisodeApi {
  final String baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Episode>> fetchEpisodes({int page = 1, String? query}) async {
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
      throw Exception('Failed to load episodes');
    }
  }
}
