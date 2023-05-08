// To parse this JSON data, do
//
//     final clanLeagueGroupResponseModel = clanLeagueGroupResponseModelFromMap(jsonString);

import 'dart:convert';

class ClanLeagueGroupResponseModel {
  ClanLeagueGroupResponseModel({
    this.state,
    this.season,
    this.clans,
    required this.rounds,
  });

  final String? state;
  final String? season;
  final List<LeagueGroupClan>? clans;
  final List<LeagueGroupRound> rounds;

  ClanLeagueGroupResponseModel copyWith({
    String? state,
    String? season,
    List<LeagueGroupClan>? clans,
    List<LeagueGroupRound>? rounds,
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
    clans: json["clans"] == null ? [] : List<LeagueGroupClan>.from(json["clans"]!.map((x) => LeagueGroupClan.fromMap(x))),
    rounds: json["rounds"] == null ? [] : List<LeagueGroupRound>.from(json["rounds"]!.map((x) => LeagueGroupRound.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "state": state,
    "season": season,
    "clans": clans == null ? [] : List<dynamic>.from(clans!.map((x) => x.toMap())),
    "rounds": rounds == null ? [] : List<dynamic>.from(rounds.map((x) => x.toMap())),
  };
}

class LeagueGroupClan {
  LeagueGroupClan({
    required this.tag,
    required this.name,
    this.clanLevel,
    this.badgeUrls,
    required this.members,
  });

  final String tag;
  final String name;
  final int? clanLevel;
  final BadgeUrls? badgeUrls;
  final List<LeagueGroupMember> members;

  LeagueGroupClan copyWith({
    String? tag,
    String? name,
    int? clanLevel,
    BadgeUrls? badgeUrls,
    List<LeagueGroupMember>? members,
  }) =>
      LeagueGroupClan(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        clanLevel: clanLevel ?? this.clanLevel,
        badgeUrls: badgeUrls ?? this.badgeUrls,
        members: members ?? this.members,
      );

  factory LeagueGroupClan.fromJson(String str) => LeagueGroupClan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeagueGroupClan.fromMap(Map<String, dynamic> json) => LeagueGroupClan(
    tag: json["tag"],
    name: json["name"],
    clanLevel: json["clanLevel"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromMap(json["badgeUrls"]),
    members: json["members"] == null ? [] : List<LeagueGroupMember>.from(json["members"]!.map((x) => LeagueGroupMember.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "clanLevel": clanLevel,
    "badgeUrls": badgeUrls?.toMap(),
    "members": members == null ? [] : List<dynamic>.from(members.map((x) => x.toMap())),
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

class LeagueGroupMember {
  LeagueGroupMember({
    required this.tag,
    required this.name,
    required this.townHallLevel,
  });

  final String tag;
  final String name;
  final int townHallLevel;

  LeagueGroupMember copyWith({
    String? tag,
    String? name,
    int? townHallLevel,
  }) =>
      LeagueGroupMember(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        townHallLevel: townHallLevel ?? this.townHallLevel,
      );

  factory LeagueGroupMember.fromJson(String str) => LeagueGroupMember.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeagueGroupMember.fromMap(Map<String, dynamic> json) => LeagueGroupMember(
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

class LeagueGroupRound {
  LeagueGroupRound({
    this.warTags,
  });

  final List<String>? warTags;

  LeagueGroupRound copyWith({
    List<String>? warTags,
  }) =>
      LeagueGroupRound(
        warTags: warTags ?? this.warTags,
      );

  factory LeagueGroupRound.fromJson(String str) => LeagueGroupRound.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeagueGroupRound.fromMap(Map<String, dynamic> json) => LeagueGroupRound(
    warTags: json["warTags"] == null ? [] : List<String>.from(json["warTags"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "warTags": warTags == null ? [] : List<dynamic>.from(warTags!.map((x) => x)),
  };
}
