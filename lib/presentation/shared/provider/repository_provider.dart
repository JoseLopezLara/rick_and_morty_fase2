// ignore_for_file: public_member_api_docs, sort_constructors_first
// De manera tecnica podemos decir que repositoryProvider es un:
// - Una clase encargada de INSTANCER todos y cada uno de mis repositorios
// - Encapsula EN UNA UNICA VARAIBLE todos los repositorios instanceados.
// - Esta varaible es la que yo puedo utlizar en mi controlador.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/api/login_api.dart';
import 'package:rick_and_morty_fase_2/data/repository/login_repository.dart';

final repositoryProvider = Provider<RepositoryProvider>((ref) {
  final loginRepository = LoginRepository(api: LoginApi());

  return RepositoryProvider(loginRepository: loginRepository);
});

class RepositoryProvider {
  final LoginRepository loginRepository;

  RepositoryProvider({
    required this.loginRepository,
  });
}
