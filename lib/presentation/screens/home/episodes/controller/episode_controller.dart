import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '/data/models/episode.dart';
import '/data/repository/episode_repository.dart';

final Logger logger = Logger();

class EpisodeController extends ChangeNotifier {
  final EpisodeRepository repository;

  // Estados para episodios paginados
  List<Episode> episodes = [];
  int currentPage = 1;
  bool isLoading = false;
  String searchQuery = '';

  // Estados para episodios de un personaje específico
  List<Episode> characterEpisodes = [];
  bool isLoadingCharacterEpisodes = false;

  EpisodeController({required this.repository});

  // Método para cargar episodios paginados
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
      logger.i('Fetching episodes (page: $currentPage, query: $searchQuery)');
      final newEpisodes = await repository.getEpisodes(
        page: currentPage,
        query: searchQuery,
      );
      episodes.addAll(newEpisodes);
      logger.i('Episodes fetched successfully. Total: ${episodes.length}');
    } catch (e, stacktrace) {
      logger.e('Error while fetching episodes',
          error: e, stackTrace: stacktrace);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método para manejar la búsqueda reactiva
  void updateSearchQuery(String query) {
    searchQuery = query;
    fetchEpisodes();
  }

  // Método para cargar episodios específicos de un personaje
  Future<void> fetchCharacterEpisodes(List<String> episodeUrls) async {
    if (isLoadingCharacterEpisodes) return;

    isLoadingCharacterEpisodes = true;
    notifyListeners();

    try {
      logger.i('Fetching episodes for character');
      final fetchedEpisodes = <Episode>[];
      for (final url in episodeUrls) {
        final episode =
            await repository.fetchEpisodeByUrl(url); // Método en el repositorio
        fetchedEpisodes.add(episode);
      }
      characterEpisodes = fetchedEpisodes;
      logger.i(
          'Character episodes fetched successfully. Total: ${characterEpisodes.length}');
    } catch (e, stacktrace) {
      logger.e('Error while fetching character episodes',
          error: e, stackTrace: stacktrace);
    } finally {
      isLoadingCharacterEpisodes = false;
      notifyListeners();
    }
  }
}
