// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rick_and_morty_fase_2/data/models/character/pagination.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';

class LocationList {
  final Pagination info;
  final List<Location> results;

  LocationList({
    required this.info,
    required this.results,
  });

  LocationList copyWith({
    Pagination? info,
    List<Location>? results,
  }) {
    return LocationList(
      info: info ?? this.info,
      results: results ?? this.results,
    );
  }

  @override
  String toString() => 'LocationList(info: $info, results: $results)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'info': info.toMap(),
      'results': results.map((x) => x.toJson()).toList(),
    };
  }

  factory LocationList.fromMap(Map<String, dynamic> map) {
    return LocationList(
      info: Pagination.fromMap(map['info'] as Map<String, dynamic>),
      results: List<Location>.from(
        (map['results'] as List<dynamic>).map<Location>(
          (x) => Location.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationList.fromJson(String source) =>
      LocationList.fromMap(json.decode(source) as Map<String, dynamic>);
}