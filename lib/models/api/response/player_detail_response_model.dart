// To parse this JSON data, do
//
//     final playerDetailResponseModel = playerDetailResponseModelFromMap(jsonString);

import 'dart:convert';

PlayerDetailResponseModel playerDetailResponseModelFromMap(String str) => PlayerDetailResponseModel.fromMap(json.decode(str));

String playerDetailResponseModelToMap(PlayerDetailResponseModel data) => json.encode(data.toMap());

class PlayerDetailResponseModel {
  String? tag;
  String? name;
  int? townHallLevel;
  int? townHallWeaponLevel;
  int? expLevel;
  int? trophies;
  int? bestTrophies;
  int? warStars;
  int? attackWins;
  int? defenseWins;
  int? builderHallLevel;
  int? builderBaseTrophies;
  int? bestBuilderBaseTrophies;
  String? role;
  String? warPreference;
  int? donations;
  int? donationsReceived;
  int? clanCapitalContributions;
  Clan? clan;
  League? league;
  BuilderBaseLeague? builderBaseLeague;
  LegendStatistics? legendStatistics;
  List<Achievement>? achievements;
  PlayerHouse? playerHouse;
  List<Label>? labels;
  List<HeroEquipment>? troops;
  List<HeroEquipment>? heroes;
  List<HeroEquipment>? heroEquipment;
  List<HeroEquipment>? spells;

  PlayerDetailResponseModel({
    this.tag,
    this.name,
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
    this.bestBuilderBaseTrophies,
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
    this.heroEquipment,
    this.spells,
  });

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
    bestBuilderBaseTrophies: json["bestBuilderBaseTrophies"],
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
    troops: json["troops"] == null ? [] : List<HeroEquipment>.from(json["troops"]!.map((x) => HeroEquipment.fromMap(x))),
    heroes: json["heroes"] == null ? [] : List<HeroEquipment>.from(json["heroes"]!.map((x) => HeroEquipment.fromMap(x))),
    heroEquipment: json["heroEquipment"] == null ? [] : List<HeroEquipment>.from(json["heroEquipment"]!.map((x) => HeroEquipment.fromMap(x))),
    spells: json["spells"] == null ? [] : List<HeroEquipment>.from(json["spells"]!.map((x) => HeroEquipment.fromMap(x))),
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
    "bestBuilderBaseTrophies": bestBuilderBaseTrophies,
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
    "heroEquipment": heroEquipment == null ? [] : List<dynamic>.from(heroEquipment!.map((x) => x.toMap())),
    "spells": spells == null ? [] : List<dynamic>.from(spells!.map((x) => x.toMap())),
  };
}

class Achievement {
  String? name;
  int? stars;
  int? value;
  int? target;
  String? info;
  String? completionInfo;
  Village? village;

  Achievement({
    this.name,
    this.stars,
    this.value,
    this.target,
    this.info,
    this.completionInfo,
    this.village,
  });

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
  CLAN_CAPITAL,
  HOME
}

final villageValues = EnumValues({
  "builderBase": Village.BUILDER_BASE,
  "clanCapital": Village.CLAN_CAPITAL,
  "home": Village.HOME
});

class BuilderBaseLeague {
  int? id;
  String? name;

  BuilderBaseLeague({
    this.id,
    this.name,
  });

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
  String? tag;
  String? name;
  int? clanLevel;
  BadgeUrls? badgeUrls;

  Clan({
    this.tag,
    this.name,
    this.clanLevel,
    this.badgeUrls,
  });

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
  String? small;
  String? large;
  String? medium;

  BadgeUrls({
    this.small,
    this.large,
    this.medium,
  });

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

class HeroEquipment {
  String? name;
  int? level;
  int? maxLevel;
  Village? village;
  List<HeroEquipment>? equipment;

  HeroEquipment({
    this.name,
    this.level,
    this.maxLevel,
    this.village,
    this.equipment,
  });

  factory HeroEquipment.fromMap(Map<String, dynamic> json) => HeroEquipment(
    name: json["name"],
    level: json["level"],
    maxLevel: json["maxLevel"],
    village: villageValues.map[json["village"]]!,
    equipment: json["equipment"] == null ? [] : List<HeroEquipment>.from(json["equipment"]!.map((x) => HeroEquipment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "level": level,
    "maxLevel": maxLevel,
    "village": villageValues.reverse[village],
    "equipment": equipment == null ? [] : List<dynamic>.from(equipment!.map((x) => x.toMap())),
  };
}

class Label {
  int? id;
  String? name;
  LabelIconUrls? iconUrls;

  Label({
    this.id,
    this.name,
    this.iconUrls,
  });

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
  String? small;
  String? medium;

  LabelIconUrls({
    this.small,
    this.medium,
  });

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
  int? id;
  String? name;
  LeagueIconUrls? iconUrls;

  League({
    this.id,
    this.name,
    this.iconUrls,
  });

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
  String? small;
  String? tiny;
  String? medium;

  LeagueIconUrls({
    this.small,
    this.tiny,
    this.medium,
  });

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
  int? legendTrophies;
  Season? previousSeason;
  Season? bestSeason;
  CurrentSeason? currentSeason;

  LegendStatistics({
    this.legendTrophies,
    this.previousSeason,
    this.bestSeason,
    this.currentSeason,
  });

  factory LegendStatistics.fromMap(Map<String, dynamic> json) => LegendStatistics(
    legendTrophies: json["legendTrophies"],
    previousSeason: json["previousSeason"] == null ? null : Season.fromMap(json["previousSeason"]),
    bestSeason: json["bestSeason"] == null ? null : Season.fromMap(json["bestSeason"]),
    currentSeason: json["currentSeason"] == null ? null : CurrentSeason.fromMap(json["currentSeason"]),
  );

  Map<String, dynamic> toMap() => {
    "legendTrophies": legendTrophies,
    "previousSeason": previousSeason?.toMap(),
    "bestSeason": bestSeason?.toMap(),
    "currentSeason": currentSeason?.toMap(),
  };
}

class Season {
  String? id;
  int? rank;
  int? trophies;

  Season({
    this.id,
    this.rank,
    this.trophies,
  });

  factory Season.fromMap(Map<String, dynamic> json) => Season(
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
  int? rank;
  int? trophies;

  CurrentSeason({
    this.rank,
    this.trophies,
  });

  factory CurrentSeason.fromMap(Map<String, dynamic> json) => CurrentSeason(
    rank: json["rank"],
    trophies: json["trophies"],
  );

  Map<String, dynamic> toMap() => {
    "rank": rank,
    "trophies": trophies,
  };
}

class PlayerHouse {
  List<Element>? elements;

  PlayerHouse({
    this.elements,
  });

  factory PlayerHouse.fromMap(Map<String, dynamic> json) => PlayerHouse(
    elements: json["elements"] == null ? [] : List<Element>.from(json["elements"]!.map((x) => Element.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toMap())),
  };
}

class Element {
  String? type;
  int? id;

  Element({
    this.type,
    this.id,
  });

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
