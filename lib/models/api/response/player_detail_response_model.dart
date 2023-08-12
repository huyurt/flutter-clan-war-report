// To parse this JSON data, do
//
//     final playerDetailResponseModel = playerDetailResponseModelFromMap(jsonString);

import 'dart:convert';

class PlayerDetailResponseModel {
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
  final int? builderBaseTrophies;
  final int? versusTrophies;
  final int? bestBuilderBaseTrophies;
  final int? bestVersusTrophies;
  final int? versusBattleWins;
  final String? role;
  final String? warPreference;
  final int? donations;
  final int? donationsReceived;
  final int? clanCapitalContributions;
  final Clan? clan;
  final League? league;
  final BuilderBaseLeague? builderBaseLeague;
  final LegendStatistics? legendStatistics;
  final List<Achievement>? achievements;
  final PlayerHouse? playerHouse;
  final List<Label>? labels;
  final List<PlayerItemLevel>? troops;
  final List<PlayerItemLevel>? heroes;
  final List<PlayerItemLevel>? spells;

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
    this.builderBaseTrophies,
    this.versusTrophies,
    this.bestBuilderBaseTrophies,
    this.bestVersusTrophies,
    this.versusBattleWins,
    this.role,
    this.warPreference,
    this.donations,
    this.donationsReceived,
    this.clanCapitalContributions,
    this.clan,
    this.league,
    this.builderBaseLeague,
    this.legendStatistics,
    this.achievements,
    this.playerHouse,
    this.labels,
    this.troops,
    this.heroes,
    this.spells,
  });

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
    int? builderBaseTrophies,
    int? versusTrophies,
    int? bestBuilderBaseTrophies,
    int? bestVersusTrophies,
    int? versusBattleWins,
    String? role,
    String? warPreference,
    int? donations,
    int? donationsReceived,
    int? clanCapitalContributions,
    Clan? clan,
    League? league,
    BuilderBaseLeague? builderBaseLeague,
    LegendStatistics? legendStatistics,
    List<Achievement>? achievements,
    PlayerHouse? playerHouse,
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
        builderBaseTrophies: builderBaseTrophies ?? this.builderBaseTrophies,
        versusTrophies: versusTrophies ?? this.versusTrophies,
        bestBuilderBaseTrophies: bestBuilderBaseTrophies ?? this.bestBuilderBaseTrophies,
        bestVersusTrophies: bestVersusTrophies ?? this.bestVersusTrophies,
        versusBattleWins: versusBattleWins ?? this.versusBattleWins,
        role: role ?? this.role,
        warPreference: warPreference ?? this.warPreference,
        donations: donations ?? this.donations,
        donationsReceived: donationsReceived ?? this.donationsReceived,
        clanCapitalContributions: clanCapitalContributions ?? this.clanCapitalContributions,
        clan: clan ?? this.clan,
        league: league ?? this.league,
        builderBaseLeague: builderBaseLeague ?? this.builderBaseLeague,
        legendStatistics: legendStatistics ?? this.legendStatistics,
        achievements: achievements ?? this.achievements,
        playerHouse: playerHouse ?? this.playerHouse,
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
    builderBaseTrophies: json["builderBaseTrophies"],
    versusTrophies: json["versusTrophies"],
    bestBuilderBaseTrophies: json["bestBuilderBaseTrophies"],
    bestVersusTrophies: json["bestVersusTrophies"],
    versusBattleWins: json["versusBattleWins"],
    role: json["role"],
    warPreference: json["warPreference"],
    donations: json["donations"],
    donationsReceived: json["donationsReceived"],
    clanCapitalContributions: json["clanCapitalContributions"],
    clan: json["clan"] == null ? null : Clan.fromMap(json["clan"]),
    league: json["league"] == null ? null : League.fromMap(json["league"]),
    builderBaseLeague: json["builderBaseLeague"] == null ? null : BuilderBaseLeague.fromMap(json["builderBaseLeague"]),
    legendStatistics: json["legendStatistics"] == null ? null : LegendStatistics.fromMap(json["legendStatistics"]),
    achievements: json["achievements"] == null ? [] : List<Achievement>.from(json["achievements"]!.map((x) => Achievement.fromMap(x))),
    playerHouse: json["playerHouse"] == null ? null : PlayerHouse.fromMap(json["playerHouse"]),
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
    "builderBaseTrophies": builderBaseTrophies,
    "versusTrophies": versusTrophies,
    "bestBuilderBaseTrophies": bestBuilderBaseTrophies,
    "bestVersusTrophies": bestVersusTrophies,
    "versusBattleWins": versusBattleWins,
    "role": role,
    "warPreference": warPreference,
    "donations": donations,
    "donationsReceived": donationsReceived,
    "clanCapitalContributions": clanCapitalContributions,
    "clan": clan?.toMap(),
    "league": league?.toMap(),
    "builderBaseLeague": builderBaseLeague?.toMap(),
    "legendStatistics": legendStatistics?.toMap(),
    "achievements": achievements == null ? [] : List<dynamic>.from(achievements!.map((x) => x.toMap())),
    "playerHouse": playerHouse?.toMap(),
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toMap())),
    "troops": troops == null ? [] : List<dynamic>.from(troops!.map((x) => x.toMap())),
    "heroes": heroes == null ? [] : List<dynamic>.from(heroes!.map((x) => x.toMap())),
    "spells": spells == null ? [] : List<dynamic>.from(spells!.map((x) => x.toMap())),
  };
}

class Achievement {
  final String? name;
  final int? stars;
  final int? value;
  final int? target;
  final String? info;
  final String? completionInfo;
  final Village? village;

  Achievement({
    this.name,
    this.stars,
    this.value,
    this.target,
    this.info,
    this.completionInfo,
    this.village,
  });

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

enum Village {
  BUILDER_BASE,
  HOME
}

final villageValues = EnumValues({
  "builderBase": Village.BUILDER_BASE,
  "home": Village.HOME
});

class BuilderBaseLeague {
  final int? id;
  final String? name;

  BuilderBaseLeague({
    this.id,
    this.name,
  });

  BuilderBaseLeague copyWith({
    int? id,
    String? name,
  }) =>
      BuilderBaseLeague(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory BuilderBaseLeague.fromJson(String str) => BuilderBaseLeague.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BuilderBaseLeague.fromMap(Map<String, dynamic> json) => BuilderBaseLeague(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

class Clan {
  final String? tag;
  final String? name;
  final int? clanLevel;
  final BadgeUrls? badgeUrls;

  Clan({
    this.tag,
    this.name,
    this.clanLevel,
    this.badgeUrls,
  });

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

class PlayerItemLevel {
  final String? name;
  final int? level;
  final int? maxLevel;
  final Village? village;

  PlayerItemLevel({
    this.name,
    this.level,
    this.maxLevel,
    this.village,
  });

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
  final int? id;
  final String? name;
  final LabelIconUrls? iconUrls;

  Label({
    this.id,
    this.name,
    this.iconUrls,
  });

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
  final String? small;
  final String? medium;

  LabelIconUrls({
    this.small,
    this.medium,
  });

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
  final int? id;
  final String? name;
  final LeagueIconUrls? iconUrls;

  League({
    this.id,
    this.name,
    this.iconUrls,
  });

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
  final String? small;
  final String? tiny;
  final String? medium;

  LeagueIconUrls({
    this.small,
    this.tiny,
    this.medium,
  });

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

class LegendStatistics {
  final int? legendTrophies;
  final BestSeason? bestBuilderBaseSeason;
  final BestSeason? bestVersusSeason;
  final CurrentSeason? currentSeason;

  LegendStatistics({
    this.legendTrophies,
    this.bestBuilderBaseSeason,
    this.bestVersusSeason,
    this.currentSeason,
  });

  LegendStatistics copyWith({
    int? legendTrophies,
    BestSeason? bestBuilderBaseSeason,
    BestSeason? bestVersusSeason,
    CurrentSeason? currentSeason,
  }) =>
      LegendStatistics(
        legendTrophies: legendTrophies ?? this.legendTrophies,
        bestBuilderBaseSeason: bestBuilderBaseSeason ?? this.bestBuilderBaseSeason,
        bestVersusSeason: bestVersusSeason ?? this.bestVersusSeason,
        currentSeason: currentSeason ?? this.currentSeason,
      );

  factory LegendStatistics.fromJson(String str) => LegendStatistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LegendStatistics.fromMap(Map<String, dynamic> json) => LegendStatistics(
    legendTrophies: json["legendTrophies"],
    bestBuilderBaseSeason: json["bestBuilderBaseSeason"] == null ? null : BestSeason.fromMap(json["bestBuilderBaseSeason"]),
    bestVersusSeason: json["bestVersusSeason"] == null ? null : BestSeason.fromMap(json["bestVersusSeason"]),
    currentSeason: json["currentSeason"] == null ? null : CurrentSeason.fromMap(json["currentSeason"]),
  );

  Map<String, dynamic> toMap() => {
    "legendTrophies": legendTrophies,
    "bestBuilderBaseSeason": bestBuilderBaseSeason?.toMap(),
    "bestVersusSeason": bestVersusSeason?.toMap(),
    "currentSeason": currentSeason?.toMap(),
  };
}

class BestSeason {
  final String? id;
  final int? rank;
  final int? trophies;

  BestSeason({
    this.id,
    this.rank,
    this.trophies,
  });

  BestSeason copyWith({
    String? id,
    int? rank,
    int? trophies,
  }) =>
      BestSeason(
        id: id ?? this.id,
        rank: rank ?? this.rank,
        trophies: trophies ?? this.trophies,
      );

  factory BestSeason.fromJson(String str) => BestSeason.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BestSeason.fromMap(Map<String, dynamic> json) => BestSeason(
    id: json["id"],
    rank: json["rank"],
    trophies: json["trophies"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "rank": rank,
    "trophies": trophies,
  };
}

class CurrentSeason {
  final int? trophies;

  CurrentSeason({
    this.trophies,
  });

  CurrentSeason copyWith({
    int? trophies,
  }) =>
      CurrentSeason(
        trophies: trophies ?? this.trophies,
      );

  factory CurrentSeason.fromJson(String str) => CurrentSeason.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CurrentSeason.fromMap(Map<String, dynamic> json) => CurrentSeason(
    trophies: json["trophies"],
  );

  Map<String, dynamic> toMap() => {
    "trophies": trophies,
  };
}

class PlayerHouse {
  final List<Element>? elements;

  PlayerHouse({
    this.elements,
  });

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
  final String? type;
  final int? id;

  Element({
    this.type,
    this.id,
  });

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
