import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/location_utils.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/provider/repository_provider.dart';

class LocationsController extends ChangeNotifier {
  final RepositoryProvider repositoryProvider;
  final String token;
  
  late UiState _pageState;
  late Location? _currentLocation;
  String? _errorMessage;

  LocationsController({required this.repositoryProvider, required this.token}) {
    _pageState = UiState.data;
    _currentLocation = null;
    _errorMessage = null;
  }

  UiState get pageState => _pageState;
  Location? get currentLocation => _currentLocation;
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
}