import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        characterState.getCharacters();
      }
    });

    _scrollController.addListener(() async {
      final position = _scrollController.offset;
      final maxExted = _scrollController.position.maxScrollExtent;

      const sensibilityScrollValue = 0.5;

      if (position > (maxExted * sensibilityScrollValue) && _canFetch) {
        // TODO: Implementar la lógica para cargar más personajes
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
