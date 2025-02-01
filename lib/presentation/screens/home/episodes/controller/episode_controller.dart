import 'package:flutter/material.dart';
import '/data/models/episode.dart';
import '/data/repository/episode_repository.dart';

class EpisodeController extends ChangeNotifier {
  final EpisodeRepository repository;
  List<Episode> episodes = [];
  int currentPage = 1;
  bool isLoading = false;
  String searchQuery = '';

  EpisodeController({required this.repository});

  Future<void> fetchEpisodes({bool loadMore = false}) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    if (loadMore) {
      currentPage++;
    } else {
      currentPage = 1;
      episodes.clear();
    }

    try {
      final newEpisodes = await repository.getEpisodes(
        page: currentPage,
        query: searchQuery,
      );
      episodes.addAll(newEpisodes);
    } catch (e) {
      // Manejo de errores
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    fetchEpisodes();
  }
}
