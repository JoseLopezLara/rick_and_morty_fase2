// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/data/models/character/character.dart';
import 'package:rick_and_morty_fase_2/data/models/character/pagination.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

class CharactersController extends ChangeNotifier {
  //Seccion 1: Definició de variables / propiedades
  final RepositoryProvider repositoryProvider;
  final String token;

  late UiState _pageState;
  late UiState _paginatioState;

  Pagination? _pagination;
  late List<Character> _characters;

  CharactersController(
      {required this.repositoryProvider, required this.token}) {
    _pageState = UiState.data;
    _paginatioState = UiState.data;
    _characters = [];
  }

  //Sección 2: Getter y setter para la lista de tareas
  List<Character> get getCurrCharacters => _characters;
  UiState get getPageState => _pageState;
  UiState get getPaginationState => _paginatioState;
  Pagination? get getPagination => _pagination;

  //Sección 3: Métodos para agregar, eliminar y actualizar tareas
  Future<void> getCharacters() async {
    // Logica referente a los componentes de carga
    final urlNextPage = _pagination?.next;
    urlNextPage == null
        ? _pageState = UiState.loading
        : _paginatioState = UiState.loading;
    notifyListeners();

    // Logica para obtener los personajes desde el repository
    try {
      logger.i('[CharactersController] getAllCharacters() | url: $urlNextPage');
      final charactersList = await repositoryProvider.charactersRepository
          .getCharacters(token, urlNextPage);

      // Valida si es la primera o posterior a la primera solicitud, dependiendo de esto,
      // asigna o adjunta los personajes a la lista de personajes.
      urlNextPage == null
          ? _characters = charactersList.results
          : _characters.addAll(charactersList.results);

      logger.i(
          '[CharactersController] getAllCharacters() | character ${_characters.length} gotten');

      _pagination = charactersList.info;
    } catch (e) {
      logger.e('[CharactersController] getAllCharacters() | error: $e');
    } finally {
      urlNextPage == null
          ? _pageState = UiState.data
          : _paginatioState = UiState.data;
    }
    notifyListeners();
  }
}
