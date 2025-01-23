// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rick_and_morty_fase_2/data/api/characters_api.dart';
import 'package:rick_and_morty_fase_2/data/models/character/character_list.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';

class CharactersRepository {
  final CharactersApi charactersApi;

  CharactersRepository({
    required this.charactersApi,
  });

  Future<CharacterList> getCharacters(String token, [String? url]) async {
    try {
      final jsonMap = await charactersApi.getCharacters(token, url);

      logger.t(
          '[CharactersRepository] getCharacters() | After to do getCharacters() api call');
      logger.d(jsonMap);

      logger.i(
          '[CharactersRepository] getCharacters() | Personajes obtenidos correctamente: ${CharacterList.fromMap(jsonMap)}');

      logger
          .t('[CharactersRepository] getCharacters() | After to do print log');

      return CharacterList.fromMap(jsonMap);
    } catch (e) {
      logger.i(
          '[CharactersRepository] getCharacters() | Error fetching characters: $e');
      rethrow;
    }
  }
}
