// To parse this JSON data, do
//
//     final playerDetailResponseModel = playerDetailResponseModelFromMap(jsonString);

import 'dart:convert';

class PlayerDetailResponseModel {
  PlayerDetailResponseModel({
    required this.tag,
    required this.name,
    this.townHallLevel,
    this.townHallWeaponLevel,
    this.expLevel,
    this.trophies,
    this.bestTrophies,
    this.warStars,
    this.attackWins,
    this.defenseWins,
    this.builderHallLevel,
    this.versusTrophies,
    this.bestVersusTrophies,
    this.versusBattleWins,
    this.role,
    this.warPreference,
    this.donations,
    this.donationsReceived,
    this.clanCapitalContributions,
    this.clan,
    this.league,
    this.achievements,
    this.playerHouse,
    this.versusBattleWinCount,
    this.labels,
    this.troops,
    this.heroes,
    this.spells,
  });

  final String tag;
  final String name;
  final int? townHallLevel;
  final int? townHallWeaponLevel;
  final int? expLevel;
  final int? trophies;
  final int? bestTrophies;
  final int? warStars;
  final int? attackWins;
  final int? defenseWins;
  final int? builderHallLevel;
  final int? versusTrophies;
  final int? bestVersusTrophies;
  final int? versusBattleWins;
  final String? role;
  final String? warPreference;
  final int? donations;
  final int? donationsReceived;
  final int? clanCapitalContributions;
  final Clan? clan;
  final League? league;
  final List<Achievement>? achievements;
  final PlayerHouse? playerHouse;
  final int? versusBattleWinCount;
  final List<Label>? labels;
  final List<PlayerItemLevel>? troops;
  final List<PlayerItemLevel>? heroes;
  final List<PlayerItemLevel>? spells;

  PlayerDetailResponseModel copyWith({
    String? tag,
    String? name,
    int? townHallLevel,
    int? townHallWeaponLevel,
    int? expLevel,
    int? trophies,
    int? bestTrophies,
    int? warStars,
    int? attackWins,
    int? defenseWins,
    int? builderHallLevel,
    int? versusTrophies,
    int? bestVersusTrophies,
    int? versusBattleWins,
    String? role,
    String? warPreference,
    int? donations,
    int? donationsReceived,
    int? clanCapitalContributions,
    Clan? clan,
    League? league,
    List<Achievement>? achievements,
    PlayerHouse? playerHouse,
    int? versusBattleWinCount,
    List<Label>? labels,
    List<PlayerItemLevel>? troops,
    List<PlayerItemLevel>? heroes,
    List<PlayerItemLevel>? spells,
  }) =>
      PlayerDetailResponseModel(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        townHallLevel: townHallLevel ?? this.townHallLevel,
        townHallWeaponLevel: townHallWeaponLevel ?? this.townHallWeaponLevel,
        expLevel: expLevel ?? this.expLevel,
        trophies: trophies ?? this.trophies,
        bestTrophies: bestTrophies ?? this.bestTrophies,
        warStars: warStars ?? this.warStars,
        attackWins: attackWins ?? this.attackWins,
        defenseWins: defenseWins ?? this.defenseWins,
        builderHallLevel: builderHallLevel ?? this.builderHallLevel,
        versusTrophies: versusTrophies ?? this.versusTrophies,
        bestVersusTrophies: bestVersusTrophies ?? this.bestVersusTrophies,
        versusBattleWins: versusBattleWins ?? this.versusBattleWins,
        role: role ?? this.role,
        warPreference: warPreference ?? this.warPreference,
        donations: donations ?? this.donations,
        donationsReceived: donationsReceived ?? this.donationsReceived,
        clanCapitalContributions: clanCapitalContributions ?? this.clanCapitalContributions,
        clan: clan ?? this.clan,
        league: league ?? this.league,
        achievements: achievements ?? this.achievements,
        playerHouse: playerHouse ?? this.playerHouse,
        versusBattleWinCount: versusBattleWinCount ?? this.versusBattleWinCount,
        labels: labels ?? this.labels,
        troops: troops ?? this.troops,
        heroes: heroes ?? this.heroes,
        spells: spells ?? this.spells,
      );

  factory PlayerDetailResponseModel.fromJson(String str) => PlayerDetailResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerDetailResponseModel.fromMap(Map<String, dynamic> json) => PlayerDetailResponseModel(
    tag: json["tag"],
    name: json["name"],
    townHallLevel: json["townHallLevel"],
    townHallWeaponLevel: json["townHallWeaponLevel"],
    expLevel: json["expLevel"],
    trophies: json["trophies"],
    bestTrophies: json["bestTrophies"],
    warStars: json["warStars"],
    attackWins: json["attackWins"],
    defenseWins: json["defenseWins"],
    builderHallLevel: json["builderHallLevel"],
    versusTrophies: json["versusTrophies"],
    bestVersusTrophies: json["bestVersusTrophies"],
    versusBattleWins: json["versusBattleWins"],
    role: json["role"],
    warPreference: json["warPreference"],
    donations: json["donations"],
    donationsReceived: json["donationsReceived"],
    clanCapitalContributions: json["clanCapitalContributions"],
    clan: json["clan"] == null ? null : Clan.fromMap(json["clan"]),
    league: json["league"] == null ? null : League.fromMap(json["league"]),
    achievements: json["achievements"] == null ? [] : List<Achievement>.from(json["achievements"]!.map((x) => Achievement.fromMap(x))),
    playerHouse: json["playerHouse"] == null ? null : PlayerHouse.fromMap(json["playerHouse"]),
    versusBattleWinCount: json["versusBattleWinCount"],
    labels: json["labels"] == null ? [] : List<Label>.from(json["labels"]!.map((x) => Label.fromMap(x))),
    troops: json["troops"] == null ? [] : List<PlayerItemLevel>.from(json["troops"]!.map((x) => PlayerItemLevel.fromMap(x))),
    heroes: json["heroes"] == null ? [] : List<PlayerItemLevel>.from(json["heroes"]!.map((x) => PlayerItemLevel.fromMap(x))),
    spells: json["spells"] == null ? [] : List<PlayerItemLevel>.from(json["spells"]!.map((x) => PlayerItemLevel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "townHallLevel": townHallLevel,
    "townHallWeaponLevel": townHallWeaponLevel,
    "expLevel": expLevel,
    "trophies": trophies,
    "bestTrophies": bestTrophies,
    "warStars": warStars,
    "attackWins": attackWins,
    "defenseWins": defenseWins,
    "builderHallLevel": builderHallLevel,
    "versusTrophies": versusTrophies,
    "bestVersusTrophies": bestVersusTrophies,
    "versusBattleWins": versusBattleWins,
    "role": role,
    "warPreference": warPreference,
    "donations": donations,
    "donationsReceived": donationsReceived,
    "clanCapitalContributions": clanCapitalContributions,
    "clan": clan?.toMap(),
    "league": league?.toMap(),
    "achievements": achievements == null ? [] : List<dynamic>.from(achievements!.map((x) => x.toMap())),
    "playerHouse": playerHouse?.toMap(),
    "versusBattleWinCount": versusBattleWinCount,
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toMap())),
    "troops": troops == null ? [] : List<dynamic>.from(troops!.map((x) => x.toMap())),
    "heroes": heroes == null ? [] : List<dynamic>.from(heroes!.map((x) => x.toMap())),
    "spells": spells == null ? [] : List<dynamic>.from(spells!.map((x) => x.toMap())),
  };
}

class Achievement {
  Achievement({
    this.name,
    this.stars,
    this.value,
    this.target,
    this.info,
    this.completionInfo,
    this.village,
  });

  final String? name;
  final int? stars;
  final int? value;
  final int? target;
  final String? info;
  final String? completionInfo;
  final Village? village;

  Achievement copyWith({
    String? name,
    int? stars,
    int? value,
    int? target,
    String? info,
    String? completionInfo,
    Village? village,
  }) =>
      Achievement(
        name: name ?? this.name,
        stars: stars ?? this.stars,
        value: value ?? this.value,
        target: target ?? this.target,
        info: info ?? this.info,
        completionInfo: completionInfo ?? this.completionInfo,
        village: village ?? this.village,
      );

  factory Achievement.fromJson(String str) => Achievement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Achievement.fromMap(Map<String, dynamic> json) => Achievement(
    name: json["name"],
    stars: json["stars"],
    value: json["value"],
    target: json["target"],
    info: json["info"],
    completionInfo: json["completionInfo"],
    village: villageValues.map[json["village"]]!,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "stars": stars,
    "value": value,
    "target": target,
    "info": info,
    "completionInfo": completionInfo,
    "village": villageValues.reverse[village],
  };
}

enum Village { HOME, BUILDER_BASE }

final villageValues = EnumValues({
  "builderBase": Village.BUILDER_BASE,
  "home": Village.HOME
});

class Clan {
  Clan({
    this.tag,
    this.name,
    this.clanLevel,
    this.badgeUrls,
  });

  final String? tag;
  final String? name;
  final int? clanLevel;
  final BadgeUrls? badgeUrls;

  Clan copyWith({
    String? tag,
    String? name,
    int? clanLevel,
    BadgeUrls? badgeUrls,
  }) =>
      Clan(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        clanLevel: clanLevel ?? this.clanLevel,
        badgeUrls: badgeUrls ?? this.badgeUrls,
      );

  factory Clan.fromJson(String str) => Clan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Clan.fromMap(Map<String, dynamic> json) => Clan(
    tag: json["tag"],
    name: json["name"],
    clanLevel: json["clanLevel"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromMap(json["badgeUrls"]),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "clanLevel": clanLevel,
    "badgeUrls": badgeUrls?.toMap(),
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

class PlayerItemLevel {
  PlayerItemLevel({
    required this.name,
    required this.level,
    required this.maxLevel,
    this.village,
  });

  final String name;
  final int level;
  final int maxLevel;
  final Village? village;

  PlayerItemLevel copyWith({
    String? name,
    int? level,
    int? maxLevel,
    Village? village,
  }) =>
      PlayerItemLevel(
        name: name ?? this.name,
        level: level ?? this.level,
        maxLevel: maxLevel ?? this.maxLevel,
        village: village ?? this.village,
      );

  factory PlayerItemLevel.fromJson(String str) => PlayerItemLevel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerItemLevel.fromMap(Map<String, dynamic> json) => PlayerItemLevel(
    name: json["name"],
    level: json["level"],
    maxLevel: json["maxLevel"],
    village: villageValues.map[json["village"]]!,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "level": level,
    "maxLevel": maxLevel,
    "village": villageValues.reverse[village],
  };
}

class Label {
  Label({
    this.id,
    this.name,
    this.iconUrls,
  });

  final int? id;
  final String? name;
  final LabelIconUrls? iconUrls;

  Label copyWith({
    int? id,
    String? name,
    LabelIconUrls? iconUrls,
  }) =>
      Label(
        id: id ?? this.id,
        name: name ?? this.name,
        iconUrls: iconUrls ?? this.iconUrls,
      );

  factory Label.fromJson(String str) => Label.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Label.fromMap(Map<String, dynamic> json) => Label(
    id: json["id"],
    name: json["name"],
    iconUrls: json["iconUrls"] == null ? null : LabelIconUrls.fromMap(json["iconUrls"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "iconUrls": iconUrls?.toMap(),
  };
}

class LabelIconUrls {
  LabelIconUrls({
    this.small,
    this.medium,
  });

  final String? small;
  final String? medium;

  LabelIconUrls copyWith({
    String? small,
    String? medium,
  }) =>
      LabelIconUrls(
        small: small ?? this.small,
        medium: medium ?? this.medium,
      );

  factory LabelIconUrls.fromJson(String str) => LabelIconUrls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LabelIconUrls.fromMap(Map<String, dynamic> json) => LabelIconUrls(
    small: json["small"],
    medium: json["medium"],
  );

  Map<String, dynamic> toMap() => {
    "small": small,
    "medium": medium,
  };
}

class League {
  League({
    this.id,
    this.name,
    this.iconUrls,
  });

  final int? id;
  final String? name;
  final LeagueIconUrls? iconUrls;

  League copyWith({
    int? id,
    String? name,
    LeagueIconUrls? iconUrls,
  }) =>
      League(
        id: id ?? this.id,
        name: name ?? this.name,
        iconUrls: iconUrls ?? this.iconUrls,
      );

  factory League.fromJson(String str) => League.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory League.fromMap(Map<String, dynamic> json) => League(
    id: json["id"],
    name: json["name"],
    iconUrls: json["iconUrls"] == null ? null : LeagueIconUrls.fromMap(json["iconUrls"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "iconUrls": iconUrls?.toMap(),
  };
}

class LeagueIconUrls {
  LeagueIconUrls({
    this.small,
    this.tiny,
    this.medium,
  });

  final String? small;
  final String? tiny;
  final String? medium;

  LeagueIconUrls copyWith({
    String? small,
    String? tiny,
    String? medium,
  }) =>
      LeagueIconUrls(
        small: small ?? this.small,
        tiny: tiny ?? this.tiny,
        medium: medium ?? this.medium,
      );

  factory LeagueIconUrls.fromJson(String str) => LeagueIconUrls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeagueIconUrls.fromMap(Map<String, dynamic> json) => LeagueIconUrls(
    small: json["small"],
    tiny: json["tiny"],
    medium: json["medium"],
  );

  Map<String, dynamic> toMap() => {
    "small": small,
    "tiny": tiny,
    "medium": medium,
  };
}

class PlayerHouse {
  PlayerHouse({
    this.elements,
  });

  final List<Element>? elements;

  PlayerHouse copyWith({
    List<Element>? elements,
  }) =>
      PlayerHouse(
        elements: elements ?? this.elements,
      );

  factory PlayerHouse.fromJson(String str) => PlayerHouse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerHouse.fromMap(Map<String, dynamic> json) => PlayerHouse(
    elements: json["elements"] == null ? [] : List<Element>.from(json["elements"]!.map((x) => Element.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toMap())),
  };
}

class Element {
  Element({
    this.type,
    this.id,
  });

  final String? type;
  final int? id;

  Element copyWith({
    String? type,
    int? id,
  }) =>
      Element(
        type: type ?? this.type,
        id: id ?? this.id,
      );

  factory Element.fromJson(String str) => Element.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Element.fromMap(Map<String, dynamic> json) => Element(
    type: json["type"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "type": type,
    "id": id,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
