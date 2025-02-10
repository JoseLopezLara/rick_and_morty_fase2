import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/api/characters_api.dart';
import 'package:rick_and_morty_fase_2/data/api/login_api.dart';
import 'package:rick_and_morty_fase_2/data/repository/characters_repository.dart';
import 'package:rick_and_morty_fase_2/data/repository/episode_repository.dart';
import 'package:rick_and_morty_fase_2/data/repository/login_repository.dart';

final repositoryProvider = Provider<RepositoryProvider>((ref) {
  final loginRepository = LoginRepository(api: LoginApi());
  final charactersRepository =
      CharactersRepository(charactersApi: CharactersApi());
  final episodeRepository =
      EpisodeRepository(baseUrl: 'https://rickandmortyapi.com/api');

  return RepositoryProvider(
    loginRepository: loginRepository,
    charactersRepository: charactersRepository,
    episodeRepository: episodeRepository,
  );
});

class RepositoryProvider {
  final LoginRepository loginRepository;
  final CharactersRepository charactersRepository;
  final EpisodeRepository episodeRepository;

  RepositoryProvider({
    required this.loginRepository,
    required this.charactersRepository,
    required this.episodeRepository,
  });
}
