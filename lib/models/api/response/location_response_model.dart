// To parse this JSON data, do
//
//     final locationModel = locationModelFromMap(jsonString);

import 'dart:convert';

class LocationModel {
  final List<LocationItem> items;
  final Paging paging;

  LocationModel({
    required this.items,
    required this.paging,
  });

  LocationModel copyWith({
    List<LocationItem>? items,
    Paging? paging,
  }) =>
      LocationModel(
        items: items ?? this.items,
        paging: paging ?? this.paging,
      );

  factory LocationModel.fromJson(String str) => LocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
    items: json["items"] == null ? [] : List<LocationItem>.from(json["items"]!.map((x) => LocationItem.fromMap(x))),
    paging: Paging.fromMap(json["paging"]),
  );

  Map<String, dynamic> toMap() => {
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
    "paging": paging.toMap(),
  };
}

class LocationItem {
  final int id;
  final String name;
  final bool isCountry;
  final String? countryCode;

  LocationItem({
    required this.id,
    required this.name,
    required this.isCountry,
    this.countryCode,
  });

  LocationItem copyWith({
    int? id,
    String? name,
    bool? isCountry,
    String? countryCode,
  }) =>
      LocationItem(
        id: id ?? this.id,
        name: name ?? this.name,
        isCountry: isCountry ?? this.isCountry,
        countryCode: countryCode ?? this.countryCode,
      );

  factory LocationItem.fromJson(String str) => LocationItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocationItem.fromMap(Map<String, dynamic> json) => LocationItem(
    id: json["id"],
    name: json["name"],
    isCountry: json["isCountry"],
    countryCode: json["countryCode"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "isCountry": isCountry,
    "countryCode": countryCode,
  };
}

class Paging {
  final Cursors? cursors;

  Paging({
    this.cursors,
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
    cursors: json["cursors"] == null ? null : Cursors.fromMap(json["cursors"]),
  );

  Map<String, dynamic> toMap() => {
    "cursors": cursors?.toMap(),
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
