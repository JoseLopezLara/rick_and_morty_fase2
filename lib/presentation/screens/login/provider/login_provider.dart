import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/controller/login_controller.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

// Paso 0: Crear provedor
final loginProvider = ChangeNotifierProvider(
    (ref) => LoginController(repositoryProvider: ref.read(repositoryProvider)));
