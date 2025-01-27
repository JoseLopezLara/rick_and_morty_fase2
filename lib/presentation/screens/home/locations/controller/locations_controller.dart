import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location_list.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/location_utils.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

class LocationsController extends ChangeNotifier {
  final RepositoryProvider repositoryProvider;
  final String token;
  
  late UiState _pageState;
  late Location? _currentLocation;
  late List<Location> _locations;
  late bool _hasMore;
  late String? _nextUrl;
  late String? _searchQuery;
  String? _errorMessage;

  LocationsController({required this.repositoryProvider, required this.token}) {
    _pageState = UiState.loading;
    _currentLocation = null;
    _locations = [];
    _hasMore = true;
    _nextUrl = null;
    _searchQuery = null;
    _errorMessage = null;
    getLocations();
  }

  UiState get pageState => _pageState;
  Location? get currentLocation => _currentLocation;
  List<Location> get locations => _locations;
  bool get hasMore => _hasMore;
  String? get nextUrl => _nextUrl;
  String? get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;

  Future<void> getLocationDetails(String url) async {
    _pageState = UiState.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final locationId = extractLocationId(url);
      if (locationId.isEmpty) {
        throw Exception('URL de ubicación inválida');
      }

      final location = await repositoryProvider.locationsRepository
          .getLocation(token, locationId);
          
      _currentLocation = location;
      _pageState = UiState.data;
    } catch (e) {
      _pageState = UiState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getLocations() async {
    try {
      final LocationList locationList = await repositoryProvider.locationsRepository
          .getLocations(token);

      _locations = locationList.results;
      _pageState = UiState.data;
      _hasMore = locationList.info.next != null;
      _nextUrl = locationList.info.next;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _pageState = UiState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMoreLocations() async {
    if (!_hasMore || _pageState == UiState.loading) return;

    try {
      _pageState = UiState.loading;
      notifyListeners();

      final LocationList locationList = await repositoryProvider.locationsRepository
          .getLocations(token, _nextUrl);

      _locations = [..._locations, ...locationList.results];
      _pageState = UiState.data;
      _hasMore = locationList.info.next != null;
      _nextUrl = locationList.info.next;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _pageState = UiState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> searchLocations(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      getLocations();
      return;
    }

    try {
      _pageState = UiState.loading;
      notifyListeners();

      final LocationList locationList = await repositoryProvider.locationsRepository
          .searchLocations(token, query);

      _locations = locationList.results;
      _pageState = UiState.data;
      _hasMore = locationList.info.next != null;
      _nextUrl = locationList.info.next;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _pageState = UiState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}