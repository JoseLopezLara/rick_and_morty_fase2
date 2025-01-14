// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

class LoginController extends ChangeNotifier {
  //Seccion 1: Definició de variables / propiedades
  RepositoryProvider repositoryProvider;

  LoginController({
    required this.repositoryProvider,
  });

  //Sección 2: Getter y setter para la lista de tareas

  //Sección 3: Métodos para agregar, eliminar y actualizar tareas
  void login(String username, String password) async {
    await repositoryProvider.loginRepository.login(username, password);

    //Paso 4 (riverpod): Emitir cambios para notificar al resto de la app
    notifyListeners();
  }
}
