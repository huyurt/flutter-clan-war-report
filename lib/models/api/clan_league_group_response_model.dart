// To parse this JSON data, do
//
//     final clanLeagueGroupResponseModel = clanLeagueGroupResponseModelFromMap(jsonString);

import 'dart:convert';

class ClanLeagueGroupResponseModel {
  ClanLeagueGroupResponseModel({
    this.state,
    this.season,
    this.clans,
    this.rounds,
  });

  final String? state;
  final String? season;
  final List<Clan>? clans;
  final List<Round>? rounds;

  ClanLeagueGroupResponseModel copyWith({
    String? state,
    String? season,
    List<Clan>? clans,
    List<Round>? rounds,
  }) =>
      ClanLeagueGroupResponseModel(
        state: state ?? this.state,
        season: season ?? this.season,
        clans: clans ?? this.clans,
        rounds: rounds ?? this.rounds,
      );

  factory ClanLeagueGroupResponseModel.fromJson(String str) => ClanLeagueGroupResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClanLeagueGroupResponseModel.fromMap(Map<String, dynamic> json) => ClanLeagueGroupResponseModel(
    state: json["state"],
    season: json["season"],
    clans: json["clans"] == null ? [] : List<Clan>.from(json["clans"]!.map((x) => Clan.fromMap(x))),
    rounds: json["rounds"] == null ? [] : List<Round>.from(json["rounds"]!.map((x) => Round.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "state": state,
    "season": season,
    "clans": clans == null ? [] : List<dynamic>.from(clans!.map((x) => x.toMap())),
    "rounds": rounds == null ? [] : List<dynamic>.from(rounds!.map((x) => x.toMap())),
  };
}

class Clan {
  Clan({
    this.tag,
    this.name,
    this.clanLevel,
    this.badgeUrls,
    this.members,
  });

  final String? tag;
  final String? name;
  final int? clanLevel;
  final BadgeUrls? badgeUrls;
  final List<Member>? members;

  Clan copyWith({
    String? tag,
    String? name,
    int? clanLevel,
    BadgeUrls? badgeUrls,
    List<Member>? members,
  }) =>
      Clan(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        clanLevel: clanLevel ?? this.clanLevel,
        badgeUrls: badgeUrls ?? this.badgeUrls,
        members: members ?? this.members,
      );

  factory Clan.fromJson(String str) => Clan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clan.fromMap(Map<String, dynamic> json) => Clan(
    tag: json["tag"],
    name: json["name"],
    clanLevel: json["clanLevel"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromMap(json["badgeUrls"]),
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "clanLevel": clanLevel,
    "badgeUrls": badgeUrls?.toMap(),
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toMap())),
  };
}

class BadgeUrls {
  BadgeUrls({
    this.small,
    this.large,
    this.medium,
  });

  final String? small;
  final String? large;
  final String? medium;

  BadgeUrls copyWith({
    String? small,
    String? large,
    String? medium,
  }) =>
      BadgeUrls(
        small: small ?? this.small,
        large: large ?? this.large,
        medium: medium ?? this.medium,
      );

  factory BadgeUrls.fromJson(String str) => BadgeUrls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BadgeUrls.fromMap(Map<String, dynamic> json) => BadgeUrls(
    small: json["small"],
    large: json["large"],
    medium: json["medium"],
  );

  Map<String, dynamic> toMap() => {
    "small": small,
    "large": large,
    "medium": medium,
  };
}

class Member {
  Member({
    this.tag,
    this.name,
    this.townHallLevel,
  });

  final String? tag;
  final String? name;
  final int? townHallLevel;

  Member copyWith({
    String? tag,
    String? name,
    int? townHallLevel,
  }) =>
      Member(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        townHallLevel: townHallLevel ?? this.townHallLevel,
      );

  factory Member.fromJson(String str) => Member.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Member.fromMap(Map<String, dynamic> json) => Member(
    tag: json["tag"],
    name: json["name"],
    townHallLevel: json["townHallLevel"],
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "townHallLevel": townHallLevel,
  };
}

class Round {
  Round({
    this.warTags,
  });

  final List<String>? warTags;

  Round copyWith({
    List<String>? warTags,
  }) =>
      Round(
        warTags: warTags ?? this.warTags,
      );

  factory Round.fromJson(String str) => Round.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Round.fromMap(Map<String, dynamic> json) => Round(
    warTags: json["warTags"] == null ? [] : List<String>.from(json["warTags"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "warTags": warTags == null ? [] : List<dynamic>.from(warTags!.map((x) => x)),
  };
}
