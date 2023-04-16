// To parse this JSON data, do
//
//     final clanWarResponseModel = clanWarResponseModelFromMap(jsonString);

import 'dart:convert';

class ClanWarResponseModel {
  ClanWarResponseModel({
    required this.state,
    this.teamSize,
    this.attacksPerMember,
    this.preparationStartTime,
    this.startTime,
    this.endTime,
    required this.clan,
    required this.opponent,
    this.warStartTime,
  });

  final String state;
  final int? teamSize;
  final int? attacksPerMember;
  final String? preparationStartTime;
  final String? startTime;
  final String? endTime;
  final Clan clan;
  final Clan opponent;
  final String? warStartTime;

  ClanWarResponseModel copyWith({
    String? state,
    int? teamSize,
    int? attacksPerMember,
    String? preparationStartTime,
    String? startTime,
    String? endTime,
    Clan? clan,
    Clan? opponent,
    String? warStartTime,
  }) =>
      ClanWarResponseModel(
        state: state ?? this.state,
        teamSize: teamSize ?? this.teamSize,
        attacksPerMember: attacksPerMember ?? this.attacksPerMember,
        preparationStartTime: preparationStartTime ?? this.preparationStartTime,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        clan: clan ?? this.clan,
        opponent: opponent ?? this.opponent,
        warStartTime: warStartTime ?? this.warStartTime,
      );

  factory ClanWarResponseModel.fromJson(String str) => ClanWarResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClanWarResponseModel.fromMap(Map<String, dynamic> json) => ClanWarResponseModel(
    state: json["state"],
    teamSize: json["teamSize"],
    attacksPerMember: json["attacksPerMember"],
    preparationStartTime: json["preparationStartTime"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    clan: Clan.fromMap(json["clan"]),
    opponent: Clan.fromMap(json["opponent"]),
    warStartTime: json["warStartTime"],
  );

  Map<String, dynamic> toMap() => {
    "state": state,
    "teamSize": teamSize,
    "attacksPerMember": attacksPerMember,
    "preparationStartTime": preparationStartTime,
    "startTime": startTime,
    "endTime": endTime,
    "clan": clan.toMap(),
    "opponent": opponent.toMap(),
    "warStartTime": warStartTime,
  };
}

class Clan {
  Clan({
    this.tag,
    this.name,
    required this.badgeUrls,
    required this.clanLevel,
    required this.attacks,
    required this.stars,
    required this.destructionPercentage,
    this.members,
  });

  final String? tag;
  final String? name;
  final BadgeUrls badgeUrls;
  final int clanLevel;
  final int attacks;
  final int stars;
  final double destructionPercentage;
  final List<Member>? members;

  Clan copyWith({
    String? tag,
    String? name,
    BadgeUrls? badgeUrls,
    int? clanLevel,
    int? attacks,
    int? stars,
    double? destructionPercentage,
    List<Member>? members,
  }) =>
      Clan(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        badgeUrls: badgeUrls ?? this.badgeUrls,
        clanLevel: clanLevel ?? this.clanLevel,
        attacks: attacks ?? this.attacks,
        stars: stars ?? this.stars,
        destructionPercentage: destructionPercentage ?? this.destructionPercentage,
        members: members ?? this.members,
      );

  factory Clan.fromJson(String str) => Clan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clan.fromMap(Map<String, dynamic> json) => Clan(
    tag: json["tag"],
    name: json["name"],
    badgeUrls: BadgeUrls.fromMap(json["badgeUrls"]),
    clanLevel: json["clanLevel"],
    attacks: json["attacks"],
    stars: json["stars"],
    destructionPercentage: json["destructionPercentage"]?.toDouble(),
    members: json["members"] == null ? [] : List<Member>.from(json["members"]!.map((x) => Member.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "badgeUrls": badgeUrls.toMap(),
    "clanLevel": clanLevel,
    "attacks": attacks,
    "stars": stars,
    "destructionPercentage": destructionPercentage,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toMap())),
  };
}

class BadgeUrls {
  BadgeUrls({
    required this.small,
    required this.large,
    required this.medium,
  });

  final String small;
  final String large;
  final String medium;

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
    required this.tag,
    required this.name,
    required this.townhallLevel,
    required this.mapPosition,
    required this.opponentAttacks,
    this.attacks,
    this.bestOpponentAttack,
  });

  final String tag;
  final String name;
  final int townhallLevel;
  final int mapPosition;
  final int opponentAttacks;
  final List<Attack>? attacks;
  final Attack? bestOpponentAttack;

  Member copyWith({
    String? tag,
    String? name,
    int? townhallLevel,
    int? mapPosition,
    int? opponentAttacks,
    List<Attack>? attacks,
    Attack? bestOpponentAttack,
  }) =>
      Member(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        townhallLevel: townhallLevel ?? this.townhallLevel,
        mapPosition: mapPosition ?? this.mapPosition,
        opponentAttacks: opponentAttacks ?? this.opponentAttacks,
        attacks: attacks ?? this.attacks,
        bestOpponentAttack: bestOpponentAttack ?? this.bestOpponentAttack,
      );

  factory Member.fromJson(String str) => Member.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Member.fromMap(Map<String, dynamic> json) => Member(
    tag: json["tag"],
    name: json["name"],
    townhallLevel: json["townhallLevel"],
    mapPosition: json["mapPosition"],
    opponentAttacks: json["opponentAttacks"],
    attacks: json["attacks"] == null ? [] : List<Attack>.from(json["attacks"]!.map((x) => Attack.fromMap(x))),
    bestOpponentAttack: json["bestOpponentAttack"] == null ? null : Attack.fromMap(json["bestOpponentAttack"]),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "townhallLevel": townhallLevel,
    "mapPosition": mapPosition,
    "opponentAttacks": opponentAttacks,
    "attacks": attacks == null ? [] : List<dynamic>.from(attacks!.map((x) => x.toMap())),
    "bestOpponentAttack": bestOpponentAttack?.toMap(),
  };
}

class Attack {
  Attack({
    this.attackerTag,
    this.defenderTag,
    this.stars,
    this.destructionPercentage,
    this.order,
    this.duration,
  });

  final String? attackerTag;
  final String? defenderTag;
  final int? stars;
  final int? destructionPercentage;
  final int? order;
  final int? duration;

  Attack copyWith({
    String? attackerTag,
    String? defenderTag,
    int? stars,
    int? destructionPercentage,
    int? order,
    int? duration,
  }) =>
      Attack(
        attackerTag: attackerTag ?? this.attackerTag,
        defenderTag: defenderTag ?? this.defenderTag,
        stars: stars ?? this.stars,
        destructionPercentage: destructionPercentage ?? this.destructionPercentage,
        order: order ?? this.order,
        duration: duration ?? this.duration,
      );

  factory Attack.fromJson(String str) => Attack.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attack.fromMap(Map<String, dynamic> json) => Attack(
    attackerTag: json["attackerTag"],
    defenderTag: json["defenderTag"],
    stars: json["stars"],
    destructionPercentage: json["destructionPercentage"],
    order: json["order"],
    duration: json["duration"],
  );

  Map<String, dynamic> toMap() => {
    "attackerTag": attackerTag,
    "defenderTag": defenderTag,
    "stars": stars,
    "destructionPercentage": destructionPercentage,
    "order": order,
    "duration": duration,
  };
}
