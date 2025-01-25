import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location_list.dart';
import 'package:rick_and_morty_fase_2/data/repository/locations_repository.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/controller/locations_controller.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/provider/locations_state.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/provider/login_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

// Antiguo provider para mantener compatibilidad
final locationsProvider =
    StateNotifierProvider<LocationsNotifier, LocationsState>((ref) {
  final repository = ref.watch(locationsRepositoryProvider);
  return LocationsNotifier(repository, ref);
});

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  final repository = ref.watch(repositoryProvider);
  return repository.locationsRepository;
});

final singleLocationProvider =
    FutureProvider.family<Location, String>((ref, locationId) async {
  final repository = ref.watch(locationsRepositoryProvider);
  final token = ref.read(loginProvider).getUser.accessToken;
  return repository.getLocation(token, locationId);
});

// Nuevo provider con ChangeNotifier
final locationsControllerProvider = ChangeNotifierProvider((ref) {
  return LocationsController(
    repositoryProvider: ref.read(repositoryProvider),
    token: ref.read(loginProvider).getUser.accessToken,
  );
});

class LocationsNotifier extends StateNotifier<LocationsState> {
  final LocationsRepository _repository;
  final Ref _ref;

  LocationsNotifier(this._repository, this._ref)
      : super(LocationsState.initial()) {
    getLocations();
  }

  Future<void> getLocations() async {
    try {
      final token = _ref.read(loginProvider).getUser.accessToken;
      final LocationList locationList = await _repository.getLocations(token);

      state = state.copyWith(
        locations: locationList.results,
        uiState: UiState.data,
        hasMore: locationList.info.next != null,
        nextUrl: locationList.info.next,
      );
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMoreLocations() async {
    if (!state.hasMore || state.uiState == UiState.loading) return;

    try {
      state = state.copyWith(uiState: UiState.loading);

      final token = _ref.read(loginProvider).getUser.accessToken;
      final LocationList locationList =
          await _repository.getLocations(token, state.nextUrl);

      state = state.copyWith(
        locations: [...state.locations, ...locationList.results],
        uiState: UiState.data,
        hasMore: locationList.info.next != null,
        nextUrl: locationList.info.next,
      );
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      getLocations();
      return;
    }

    try {
      state = state.copyWith(
        uiState: UiState.loading,
        searchQuery: query,
      );

      final token = _ref.read(loginProvider).getUser.accessToken;
      final LocationList locationList =
          await _repository.searchLocations(token, query);

      state = state.copyWith(
        locations: locationList.results,
        uiState: UiState.data,
        hasMore: locationList.info.next != null,
        nextUrl: locationList.info.next,
      );
    } catch (e) {
      state = state.copyWith(
        uiState: UiState.error,
        errorMessage: e.toString(),
      );
    }
  }
}