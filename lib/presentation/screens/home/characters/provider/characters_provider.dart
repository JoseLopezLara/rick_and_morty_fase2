import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/models/character/character_list.dart';
import 'package:rick_and_morty_fase_2/data/repository/characters_repository.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/provider/characters_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

final charactersProvider =
    StateNotifierProvider<CharactersNotifier, CharactersState>((ref) {
  final repository = ref.watch(charactersRepositoryProvider);
  return CharactersNotifier(repository, ref);
});

final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  final repository = ref.watch(repositoryProvider);
  return repository.charactersRepository;
});

class CharactersNotifier extends StateNotifier<CharactersState> {
  final CharactersRepository _repository;
  final Ref _ref;

  CharactersNotifier(this._repository, this._ref)
      : super(CharactersState.initial()) {
    getCharacters();
  }

  Future<void> getCharacters() async {
    try {
      final token = ''; // TODO: Implement token management
      final CharacterList characterList = await _repository.getCharacters(token);

      state = state.copyWith(
        characters: characterList.results,
        uiState: UiState.data,
        hasMore: characterList.info.next != null,
        nextUrl: characterList.info.next,
      );
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMoreCharacters() async {
    if (!state.hasMore || state.uiState == UiState.loading) return;

    try {
      state = state.copyWith(uiState: UiState.loading);

      final token = ''; // TODO: Implement token management
      final CharacterList characterList =
          await _repository.getCharacters(token, state.nextUrl);

      state = state.copyWith(
        characters: [...state.characters, ...characterList.results],
        uiState: UiState.data,
        hasMore: characterList.info.next != null,
        nextUrl: characterList.info.next,
      );
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }
}