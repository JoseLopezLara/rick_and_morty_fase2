
import 'package:rick_and_morty_fase_2/data/api/locations_api.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location_list.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';

class LocationsRepository {
  final LocationsApi locationsApi;

  LocationsRepository({
    required this.locationsApi,
  });

  Future<LocationList> getLocations(String token, [String? url]) async {
    try {
      final jsonMap = await locationsApi.getLocations(token, url);

      logger.t(
          '[LocationsRepository] getLocations() | After to do getLocations() api call');
      logger.d(jsonMap);

      logger.i(
          '[LocationsRepository] getLocations() | Ubicaciones obtenidas correctamente: ${LocationList.fromMap(jsonMap)}');

      return LocationList.fromMap(jsonMap);
    } catch (e) {
      logger.e(
          '[LocationsRepository] getLocations() | Error al obtener ubicaciones: $e');
      rethrow;
    }
  }

  Future<Location> getLocation(String token, String locationId) async {
    try {
      final jsonMap = await locationsApi.getLocation(token, locationId);

      logger.t(
          '[LocationsRepository] getLocation() | After to do getLocation() api call');
      logger.d(jsonMap);

      logger.i(
          '[LocationsRepository] getLocation() | Ubicación obtenida correctamente: ${Location.fromJson(jsonMap)}');

      return Location.fromJson(jsonMap);
    } catch (e) {
      logger.e(
          '[LocationsRepository] getLocation() | Error al obtener ubicación: $e');
      rethrow;
    }
  }

  Future<LocationList> searchLocations(String token, String name) async {
    try {
      final jsonMap = await locationsApi.searchLocations(token, name);

      logger.t(
          '[LocationsRepository] searchLocations() | After to do searchLocations() api call');
      logger.d(jsonMap);

      logger.i(
          '[LocationsRepository] searchLocations() | Búsqueda realizada correctamente: ${LocationList.fromMap(jsonMap)}');

      return LocationList.fromMap(jsonMap);
    } catch (e) {
      logger.e(
          '[LocationsRepository] searchLocations() | Error en la búsqueda: $e');
      rethrow;
    }
  }
}