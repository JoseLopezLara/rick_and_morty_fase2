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
        _scrollController.position.maxScrollExtent * 0.85) {
      ref.read(charactersProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(charactersProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _buildCharactersList(state),
                ),
                if (state.uiState == UiState.loading && state.characters.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
            if (state.uiState == UiState.loading && state.characters.isEmpty)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharactersList(CharactersState state) {
    if (state.uiState == UiState.error && state.characters.isEmpty) {
      return Center(
        child: Text('Error: ${state.errorMessage}'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.characters.length,
      itemBuilder: (context, index) {
        final character = state.characters[index];
        return CharacterCard(character: character);
      },
    );
  }
}