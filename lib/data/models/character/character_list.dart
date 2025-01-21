// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rick_and_morty_fase_2/data/models/character/character.dart';
import 'package:rick_and_morty_fase_2/data/models/character/pagination.dart';

class CharacterList {
  final Pagination info;
  final List<Character> results;

  CharacterList({
    required this.info,
    required this.results,
  });

  CharacterList copyWith({
    Pagination? info,
    List<Character>? results,
  }) {
    return CharacterList(
      info: info ?? this.info,
      results: results ?? this.results,
    );
  }

  @override
  String toString() => 'CharacterList(info: $info, results: $results)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'info': info.toMap(),
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory CharacterList.fromMap(Map<String, dynamic> map) {
    return CharacterList(
      info: Pagination.fromMap(map['info'] as Map<String, dynamic>),
      results: List<Character>.from(
        (map['results'] as List<dynamic>).map<Character>(
          (x) => Character.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterList.fromJson(String source) =>
      CharacterList.fromMap(json.decode(source) as Map<String, dynamic>);
}
