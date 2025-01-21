import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/providers/characters_provider.dart';

//Migrar STF A Riverpod P1: extends ConsumerStatefulWidget
class CharacteresScreen extends ConsumerStatefulWidget {
  const CharacteresScreen({super.key});

//Migrar STF A Riverpod P2: ConsumerState<CharacteresScreen>
  @override
  ConsumerState<CharacteresScreen> createState() => _CharacteresScreenState();
}

//Migrar STF A Riverpod P3: ConsumerState<CharacteresScreen>
class _CharacteresScreenState extends ConsumerState<CharacteresScreen> {
  //LOGICA DEL WIDGET:
  // ----------------------------------
  late ScrollController _scrollController;
  bool _canFetch = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    final characterState = ref.read(characterProvider);

    // WidgetsBinding se manda a llamar cuando termina
    // de rendrerizarse el ultimo frame de mi scree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (characterState.getCurrCharacters.isEmpty) {
        logger.i('[CharacteresScreen] initState() | call to getCharacters()');
        characterState.getCharacters();
      }
    });

    _scrollController.addListener(() async {
      final position = _scrollController.offset;
      final maxExted = _scrollController.position.maxScrollExtent;

      const sensibilityScrollValue = 0.5;

      if (position > (maxExted * sensibilityScrollValue) && _canFetch) {
        _canFetch = false;
        try {
          characterState.getCharacters();
        } catch (e) {
          logger.e('[CharacteresScreen] initState() | error: $e');
        } finally {
          _canFetch = true;
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterProvider);
    final currCharacters = characterState.getCurrCharacters;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: currCharacters.length,
                itemBuilder: (contex, index) {
                  final character = currCharacters[index];

                  return Container(
                    key: Key(
                        'rick_and_morty_character_${character.id.toString()}'),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Card(
                      color: Colors.grey[100],
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                character.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   flex: 3,
                          //   child: ))
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          )
        ],
      ),
    );
  }
}
