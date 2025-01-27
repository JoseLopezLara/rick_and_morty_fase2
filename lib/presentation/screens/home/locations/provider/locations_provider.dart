import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/controller/locations_controller.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/provider/login_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

final locationsControllerProvider = ChangeNotifierProvider((ref) {
  return LocationsController(
    repositoryProvider: ref.read(repositoryProvider),
    token: ref.read(loginProvider).getUser.accessToken,
  );
});