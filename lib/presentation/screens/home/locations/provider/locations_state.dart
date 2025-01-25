import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

class LocationsState {
  final List<Location> locations;
  final UiState uiState;
  final String? errorMessage;
  final bool hasMore;
  final String? nextUrl;
  final String? searchQuery;

  LocationsState({
    required this.locations,
    required this.uiState,
    this.errorMessage,
    required this.hasMore,
    this.nextUrl,
    this.searchQuery,
  });

  factory LocationsState.initial() {
    return LocationsState(
      locations: [],
      uiState: UiState.loading,
      hasMore: true,
    );
  }

  LocationsState copyWith({
    List<Location>? locations,
    UiState? uiState,
    String? errorMessage,
    bool? hasMore,
    String? nextUrl,
    String? searchQuery,
  }) {
    return LocationsState(
      locations: locations ?? this.locations,
      uiState: uiState ?? this.uiState,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      nextUrl: nextUrl ?? this.nextUrl,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}