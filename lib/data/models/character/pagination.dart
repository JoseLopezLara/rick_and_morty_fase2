import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Pagination {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Pagination({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  Pagination copyWith({
    int? count,
    int? pages,
    String? next,
    String? prev,
  }) {
    return Pagination(
      count: count ?? this.count,
      pages: pages ?? this.pages,
      next: next ?? this.next,
      prev: prev ?? this.prev,
    );
  }

  @override
  String toString() {
    return 'Pagination(count: $count, pages: $pages, next: $next, prev: $prev)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      count: map['count'] as int,
      pages: map['pages'] as int,
      next: map['next'] != null ? map['next'] as String : null,
      prev: map['prev'] != null ? map['prev'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pagination.fromJson(String source) =>
      Pagination.fromMap(json.decode(source) as Map<String, dynamic>);
}
