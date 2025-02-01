// lib/data/repository/episode_repository.dart
import '../api/episode_api.dart';
import '../models/episode.dart';

class EpisodeRepository {
  final EpisodeApi api;

  EpisodeRepository({required this.api});

  Future<List<Episode>> getEpisodes({int page = 1, String? query}) {
    return api.fetchEpisodes(page: page, query: query);
  }
}
