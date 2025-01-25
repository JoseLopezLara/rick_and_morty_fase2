import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/provider/characters_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/provider/characters_state.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/widgets/character_card.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      ref.read(charactersProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(charactersProvider);

    return Scaffold(
      body: _buildCharactersList(state),
    );
  }

  Widget _buildCharactersList(CharactersState state) {
    switch (state.uiState) {
      case UiState.loading:
        if (state.characters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        break;
      case UiState.error:
        if (state.characters.isEmpty) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }
        break;
      case UiState.data:
        break;
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.characters.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.characters.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = state.characters[index];
        return CharacterCard(character: character);
      },
    );
  }
}