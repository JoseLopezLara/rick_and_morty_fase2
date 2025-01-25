import 'package:rick_and_morty_fase_2/data/models/character/character.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

class CharactersState {
  final List<Character> characters;
  final UiState uiState;
  final String? errorMessage;
  final bool hasMore;
  final String? nextUrl;

  CharactersState({
    required this.characters,
    required this.uiState,
    this.errorMessage,
    required this.hasMore,
    this.nextUrl,
  });

  factory CharactersState.initial() {
    return CharactersState(
      characters: [],
      uiState: UiState.loading,
      hasMore: true,
    );
  }

  CharactersState copyWith({
    List<Character>? characters,
    UiState? uiState,
    String? errorMessage,
    bool? hasMore,
    String? nextUrl,
  }) {
    return CharactersState(
      characters: characters ?? this.characters,
      uiState: uiState ?? this.uiState,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      nextUrl: nextUrl ?? this.nextUrl,
    );
  }
}