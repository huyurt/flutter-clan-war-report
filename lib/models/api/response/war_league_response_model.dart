// To parse this JSON data, do
//
//     final warLeagueResponseModel = warLeagueResponseModelFromMap(jsonString);

import 'dart:convert';

class WarLeagueResponseModel {
  final List<WarLeagueItem> items;
  final Paging paging;

  WarLeagueResponseModel({
    required this.items,
    required this.paging,
  });

  WarLeagueResponseModel copyWith({
    List<WarLeagueItem>? items,
    Paging? paging,
  }) =>
      WarLeagueResponseModel(
        items: items ?? this.items,
        paging: paging ?? this.paging,
      );

  factory WarLeagueResponseModel.fromJson(String str) => WarLeagueResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarLeagueResponseModel.fromMap(Map<String, dynamic> json) => WarLeagueResponseModel(
    items: json["items"] == null ? [] : List<WarLeagueItem>.from(json["items"]!.map((x) => WarLeagueItem.fromMap(x))),
    paging: Paging.fromMap(json["paging"]),
  );

  Map<String, dynamic> toMap() => {
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toMap())),
    "paging": paging.toMap(),
  };
}

class WarLeagueItem {
  final int id;
  final String name;

  WarLeagueItem({
    required this.id,
    required this.name,
  });

  WarLeagueItem copyWith({
    int? id,
    String? name,
  }) =>
      WarLeagueItem(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory WarLeagueItem.fromJson(String str) => WarLeagueItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarLeagueItem.fromMap(Map<String, dynamic> json) => WarLeagueItem(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

class Paging {
  final Cursors cursors;

  Paging({
    required this.cursors,
  });

  Paging copyWith({
    Cursors? cursors,
  }) =>
      Paging(
        cursors: cursors ?? this.cursors,
      );

  factory Paging.fromJson(String str) => Paging.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Paging.fromMap(Map<String, dynamic> json) => Paging(
    cursors: Cursors.fromMap(json["cursors"]),
  );

  Map<String, dynamic> toMap() => {
    "cursors": cursors.toMap(),
  };
}

class Cursors {
  final String? after;
  final String? before;

  Cursors({
    this.after,
    this.before,
  });

  Cursors copyWith({
    String? after,
    String? before,
  }) =>
      Cursors(
        after: after ?? this.after,
        before: before ?? this.before,
      );

  factory Cursors.fromJson(String str) => Cursors.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cursors.fromMap(Map<String, dynamic> json) => Cursors(
    after: json["after"],
    before: json["before"],
  );

  Map<String, dynamic> toMap() => {
    "after": after,
    "before": before,
  };
}
