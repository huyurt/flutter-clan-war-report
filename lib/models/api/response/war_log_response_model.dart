// To parse this JSON data, do
//
//     final warLogModel = warLogModelFromMap(jsonString);

import 'dart:convert';

class WarLogResponseModel {
  final List<WarLogItem> items;
  final Paging paging;

  WarLogResponseModel({
    required this.items,
    required this.paging,
  });

  WarLogResponseModel copyWith({
    List<WarLogItem>? items,
    Paging? paging,
  }) =>
      WarLogResponseModel(
        items: items ?? this.items,
        paging: paging ?? this.paging,
      );

  factory WarLogResponseModel.fromJson(String str) => WarLogResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarLogResponseModel.fromMap(Map<String, dynamic> json) => WarLogResponseModel(
    items: json["items"] == null ? [] : List<WarLogItem>.from(json["items"]!.map((x) => WarLogItem.fromMap(x))),
    paging: Paging.fromMap(json["paging"]),
  );

  Map<String, dynamic> toMap() => {
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toMap())),
    "paging": paging.toMap(),
  };
}

class WarLogItem {
  final String? result;
  final String? endTime;
  final int? teamSize;
  final int? attacksPerMember;
  final WarLogClan clan;
  final WarLogClan opponent;

  WarLogItem({
    this.result,
    this.endTime,
    this.teamSize,
    this.attacksPerMember,
    required this.clan,
    required this.opponent,
  });

  WarLogItem copyWith({
    String? result,
    String? endTime,
    int? teamSize,
    int? attacksPerMember,
    WarLogClan? clan,
    WarLogClan? opponent,
  }) =>
      WarLogItem(
        result: result ?? this.result,
        endTime: endTime ?? this.endTime,
        teamSize: teamSize ?? this.teamSize,
        attacksPerMember: attacksPerMember ?? this.attacksPerMember,
        clan: clan ?? this.clan,
        opponent: opponent ?? this.opponent,
      );

  factory WarLogItem.fromJson(String str) => WarLogItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarLogItem.fromMap(Map<String, dynamic> json) => WarLogItem(
    result: json["result"],
    endTime: json["endTime"],
    teamSize: json["teamSize"],
    attacksPerMember: json["attacksPerMember"],
    clan: WarLogClan.fromMap(json["clan"]),
    opponent: WarLogClan.fromMap(json["opponent"]),
  );

  Map<String, dynamic> toMap() => {
    "result": result,
    "endTime": endTime,
    "teamSize": teamSize,
    "attacksPerMember": attacksPerMember,
    "clan": clan.toMap(),
    "opponent": opponent?.toMap(),
  };
}

class WarLogClan {
  final String? tag;
  final String? name;
  final BadgeUrls? badgeUrls;
  final int? clanLevel;
  final int? attacks;
  final int stars;
  final double destructionPercentage;
  final int? expEarned;

  WarLogClan({
    this.tag,
    this.name,
    this.badgeUrls,
    this.clanLevel,
    this.attacks,
    required this.stars,
    required this.destructionPercentage,
    this.expEarned,
  });

  WarLogClan copyWith({
    String? tag,
    String? name,
    BadgeUrls? badgeUrls,
    int? clanLevel,
    int? attacks,
    int? stars,
    double? destructionPercentage,
    int? expEarned,
  }) =>
      WarLogClan(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        badgeUrls: badgeUrls ?? this.badgeUrls,
        clanLevel: clanLevel ?? this.clanLevel,
        attacks: attacks ?? this.attacks,
        stars: stars ?? this.stars,
        destructionPercentage: destructionPercentage ?? this.destructionPercentage,
        expEarned: expEarned ?? this.expEarned,
      );

  factory WarLogClan.fromJson(String str) => WarLogClan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarLogClan.fromMap(Map<String, dynamic> json) => WarLogClan(
    tag: json["tag"],
    name: json["name"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromMap(json["badgeUrls"]),
    clanLevel: json["clanLevel"],
    attacks: json["attacks"],
    stars: json["stars"],
    destructionPercentage: json["destructionPercentage"]?.toDouble(),
    expEarned: json["expEarned"],
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "badgeUrls": badgeUrls?.toMap(),
    "clanLevel": clanLevel,
    "attacks": attacks,
    "stars": stars,
    "destructionPercentage": destructionPercentage,
    "expEarned": expEarned,
  };
}

class BadgeUrls {
  final String? small;
  final String? large;
  final String? medium;

  BadgeUrls({
    this.small,
    this.large,
    this.medium,
  });

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
