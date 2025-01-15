// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/data/models/user.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/utilis/logger.dart';

import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

class LoginController extends ChangeNotifier {
  //Seccion 1: Definició de variables / propiedades
  RepositoryProvider repositoryProvider;
  late User _user;
  late UiState _uiState;

  LoginController({
    required this.repositoryProvider,
  }) {
    _uiState = UiState.data;
  }

  //Sección 2: Getter y setter para la lista de tareas
  User get getUser => _user;
  UiState get getUiState => _uiState;

  //Sección 3: Métodos para agregar, eliminar y actualizar tareas
  Future<void> login(String username, String password) async {
    // Cambio el estado de enum a loading y lanzo el notifyListeners para comunicar
    // a mi UI que debe de mostrar en componte de carga.
    _uiState = UiState.loading;
    notifyListeners();

    logger.d(
        "[LoginController]: login() function called with username $username password $password");

    try {
      logger.d("[LoginController]: login() into try");
      _user =
          await repositoryProvider.loginRepository.login(username, password);
      logger.d(
          "[LoginController]: login() was a success request: ${_user.toString()}");
    } catch (error) {
      logger.e("[LoginController]: login() request failed: $error");
      // Cambio el estado de enum a error y lanzo el notifyListeners para comunicar
      // a mi UI que debe de mostrar en componte de carga.
      _uiState = UiState.error;
      notifyListeners();
      rethrow;
    } finally {
      logger.d("[LoginController]: login() finally called");
      // Cambio el estado de enum a data y lanzo el notifyListeners para comunicar
      // a mi UI que debe de mostrar en componte de carga.
      _uiState = UiState.data;
      notifyListeners();
    }

    //Paso 4 (riverpod): Emitir cambios para notificar al resto de la app
    notifyListeners();
  }
}
