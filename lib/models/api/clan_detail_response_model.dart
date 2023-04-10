import 'dart:convert';

ClanDetailResponseModel clanDetailResponseFromJson(String str) =>
    ClanDetailResponseModel.fromJson(json.decode(str));

String clanDetailResponseToJson(ClanDetailResponseModel data) =>
    json.encode(data.toJson());

class ClanDetailResponseModel {
  ClanDetailResponseModel({
    required this.tag,
    required this.name,
    required this.type,
    this.description,
    this.location,
    this.isFamilyFriendly,
    this.badgeUrls,
    this.clanLevel,
    this.clanPoints,
    this.clanVersusPoints,
    this.clanCapitalPoints,
    this.capitalLeague,
    this.requiredTrophies,
    this.warFrequency,
    this.warWinStreak,
    this.warWins,
    this.warTies,
    this.warLosses,
    this.isWarLogPublic,
    this.warLeague,
    this.members,
    this.memberList,
    this.labels,
    this.requiredVersusTrophies,
    this.requiredTownhallLevel,
    this.clanCapital,
    this.chatLanguage,
  });

  final String tag;
  final String name;
  final String type;
  final String? description;
  final Location? location;
  final bool? isFamilyFriendly;
  final BadgeUrls? badgeUrls;
  final int? clanLevel;
  final int? clanPoints;
  final int? clanVersusPoints;
  final int? clanCapitalPoints;
  final League? capitalLeague;
  final int? requiredTrophies;
  final String? warFrequency;
  final int? warWinStreak;
  final int? warWins;
  final int? warTies;
  final int? warLosses;
  final bool? isWarLogPublic;
  final League? warLeague;
  final int? members;
  final List<Member>? memberList;
  final List<Label>? labels;
  final int? requiredVersusTrophies;
  final int? requiredTownhallLevel;
  final ClanCapital? clanCapital;
  final ChatLanguage? chatLanguage;

  ClanDetailResponseModel copyWith({
    String? tag,
    String? name,
    String? type,
    String? description,
    Location? location,
    bool? isFamilyFriendly,
    BadgeUrls? badgeUrls,
    int? clanLevel,
    int? clanPoints,
    int? clanVersusPoints,
    int? clanCapitalPoints,
    League? capitalLeague,
    int? requiredTrophies,
    String? warFrequency,
    int? warWinStreak,
    int? warWins,
    int? warTies,
    int? warLosses,
    bool? isWarLogPublic,
    League? warLeague,
    int? members,
    List<Member>? memberList,
    List<Label>? labels,
    int? requiredVersusTrophies,
    int? requiredTownhallLevel,
    ClanCapital? clanCapital,
    ChatLanguage? chatLanguage,
  }) =>
      ClanDetailResponseModel(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        location: location ?? this.location,
        isFamilyFriendly: isFamilyFriendly ?? this.isFamilyFriendly,
        badgeUrls: badgeUrls ?? this.badgeUrls,
        clanLevel: clanLevel ?? this.clanLevel,
        clanPoints: clanPoints ?? this.clanPoints,
        clanVersusPoints: clanVersusPoints ?? this.clanVersusPoints,
        clanCapitalPoints: clanCapitalPoints ?? this.clanCapitalPoints,
        capitalLeague: capitalLeague ?? this.capitalLeague,
        requiredTrophies: requiredTrophies ?? this.requiredTrophies,
        warFrequency: warFrequency ?? this.warFrequency,
        warWinStreak: warWinStreak ?? this.warWinStreak,
        warWins: warWins ?? this.warWins,
        warTies: warTies ?? this.warTies,
        warLosses: warLosses ?? this.warLosses,
        isWarLogPublic: isWarLogPublic ?? this.isWarLogPublic,
        warLeague: warLeague ?? this.warLeague,
        members: members ?? this.members,
        memberList: memberList ?? this.memberList,
        labels: labels ?? this.labels,
        requiredVersusTrophies:
            requiredVersusTrophies ?? this.requiredVersusTrophies,
        requiredTownhallLevel:
            requiredTownhallLevel ?? this.requiredTownhallLevel,
        clanCapital: clanCapital ?? this.clanCapital,
        chatLanguage: chatLanguage ?? this.chatLanguage,
      );

  factory ClanDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      ClanDetailResponseModel(
        tag: json["tag"],
        name: json["name"],
        type: json["type"],
        description: json["description"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        isFamilyFriendly: json["isFamilyFriendly"],
        badgeUrls: json["badgeUrls"] == null
            ? null
            : BadgeUrls.fromJson(json["badgeUrls"]),
        clanLevel: json["clanLevel"],
        clanPoints: json["clanPoints"],
        clanVersusPoints: json["clanVersusPoints"],
        clanCapitalPoints: json["clanCapitalPoints"],
        capitalLeague: json["capitalLeague"] == null
            ? null
            : League.fromJson(json["capitalLeague"]),
        requiredTrophies: json["requiredTrophies"],
        warFrequency: json["warFrequency"],
        warWinStreak: json["warWinStreak"],
        warWins: json["warWins"],
        warTies: json["warTies"],
        warLosses: json["warLosses"],
        isWarLogPublic: json["isWarLogPublic"],
        warLeague: json["warLeague"] == null
            ? null
            : League.fromJson(json["warLeague"]),
        members: json["members"],
        memberList: json["memberList"] == null
            ? []
            : List<Member>.from(
                json["memberList"]!.map((x) => Member.fromJson(x))),
        labels: json["labels"] == null
            ? []
            : List<Label>.from(json["labels"]!.map((x) => Label.fromJson(x))),
        requiredVersusTrophies: json["requiredVersusTrophies"],
        requiredTownhallLevel: json["requiredTownhallLevel"],
        clanCapital: json["clanCapital"] == null
            ? null
            : ClanCapital.fromJson(json["clanCapital"]),
        chatLanguage: json["chatLanguage"] == null
            ? null
            : ChatLanguage.fromJson(json["chatLanguage"]),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "type": type,
        "description": description,
        "location": location?.toJson(),
        "isFamilyFriendly": isFamilyFriendly,
        "badgeUrls": badgeUrls?.toJson(),
        "clanLevel": clanLevel,
        "clanPoints": clanPoints,
        "clanVersusPoints": clanVersusPoints,
        "clanCapitalPoints": clanCapitalPoints,
        "capitalLeague": capitalLeague?.toJson(),
        "requiredTrophies": requiredTrophies,
        "warFrequency": warFrequency,
        "warWinStreak": warWinStreak,
        "warWins": warWins,
        "warTies": warTies,
        "warLosses": warLosses,
        "isWarLogPublic": isWarLogPublic,
        "warLeague": warLeague?.toJson(),
        "members": members,
        "memberList": memberList == null
            ? []
            : List<dynamic>.from(memberList!.map((x) => x.toJson())),
        "labels": labels == null
            ? []
            : List<dynamic>.from(labels!.map((x) => x.toJson())),
        "requiredVersusTrophies": requiredVersusTrophies,
        "requiredTownhallLevel": requiredTownhallLevel,
        "clanCapital": clanCapital?.toJson(),
        "chatLanguage": chatLanguage?.toJson(),
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

  factory BadgeUrls.fromJson(Map<String, dynamic> json) => BadgeUrls(
        small: json["small"],
        large: json["large"],
        medium: json["medium"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "large": large,
        "medium": medium,
      };
}

class League {
  League({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  League copyWith({
    int? id,
    String? name,
  }) =>
      League(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ChatLanguage {
  ChatLanguage({
    this.id,
    this.name,
    this.languageCode,
  });

  final int? id;
  final String? name;
  final String? languageCode;

  ChatLanguage copyWith({
    int? id,
    String? name,
    String? languageCode,
  }) =>
      ChatLanguage(
        id: id ?? this.id,
        name: name ?? this.name,
        languageCode: languageCode ?? this.languageCode,
      );

  factory ChatLanguage.fromJson(Map<String, dynamic> json) => ChatLanguage(
        id: json["id"],
        name: json["name"],
        languageCode: json["languageCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "languageCode": languageCode,
      };
}

class ClanCapital {
  ClanCapital({
    this.capitalHallLevel,
    this.districts,
  });

  final int? capitalHallLevel;
  final List<District>? districts;

  ClanCapital copyWith({
    int? capitalHallLevel,
    List<District>? districts,
  }) =>
      ClanCapital(
        capitalHallLevel: capitalHallLevel ?? this.capitalHallLevel,
        districts: districts ?? this.districts,
      );

  factory ClanCapital.fromJson(Map<String, dynamic> json) => ClanCapital(
        capitalHallLevel: json["capitalHallLevel"],
        districts: json["districts"] == null
            ? []
            : List<District>.from(
                json["districts"]!.map((x) => District.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "capitalHallLevel": capitalHallLevel,
        "districts": districts == null
            ? []
            : List<dynamic>.from(districts!.map((x) => x.toJson())),
      };
}

class District {
  District({
    this.id,
    this.name,
    this.districtHallLevel,
  });

  final int? id;
  final String? name;
  final int? districtHallLevel;

  District copyWith({
    int? id,
    String? name,
    int? districtHallLevel,
  }) =>
      District(
        id: id ?? this.id,
        name: name ?? this.name,
        districtHallLevel: districtHallLevel ?? this.districtHallLevel,
      );

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        name: json["name"],
        districtHallLevel: json["districtHallLevel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "districtHallLevel": districtHallLevel,
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

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        name: json["name"],
        iconUrls: json["iconUrls"] == null
            ? null
            : LabelIconUrls.fromJson(json["iconUrls"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls?.toJson(),
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

  factory LabelIconUrls.fromJson(Map<String, dynamic> json) => LabelIconUrls(
        small: json["small"],
        medium: json["medium"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
      };
}

class Location {
  Location({
    this.id,
    this.name,
    this.isCountry,
    this.countryCode,
  });

  final int? id;
  final String? name;
  final bool? isCountry;
  final String? countryCode;

  Location copyWith({
    int? id,
    String? name,
    bool? isCountry,
    String? countryCode,
  }) =>
      Location(
        id: id ?? this.id,
        name: name ?? this.name,
        isCountry: isCountry ?? this.isCountry,
        countryCode: countryCode ?? this.countryCode,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        isCountry: json["isCountry"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isCountry": isCountry,
        "countryCode": countryCode,
      };
}

class Member {
  Member({
    required this.tag,
    required this.name,
    this.role,
    this.expLevel,
    this.league,
    this.trophies,
    this.versusTrophies,
    this.clanRank,
    this.previousClanRank,
    this.donations,
    this.donationsReceived,
    this.playerHouse,
  });

  final String tag;
  final String name;
  final String? role;
  final int? expLevel;
  final LeagueClass? league;
  final int? trophies;
  final int? versusTrophies;
  final int? clanRank;
  final int? previousClanRank;
  final int? donations;
  final int? donationsReceived;
  final PlayerHouse? playerHouse;

  Member copyWith({
    String? tag,
    String? name,
    String? role,
    int? expLevel,
    LeagueClass? league,
    int? trophies,
    int? versusTrophies,
    int? clanRank,
    int? previousClanRank,
    int? donations,
    int? donationsReceived,
    PlayerHouse? playerHouse,
  }) =>
      Member(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        role: role ?? this.role,
        expLevel: expLevel ?? this.expLevel,
        league: league ?? this.league,
        trophies: trophies ?? this.trophies,
        versusTrophies: versusTrophies ?? this.versusTrophies,
        clanRank: clanRank ?? this.clanRank,
        previousClanRank: previousClanRank ?? this.previousClanRank,
        donations: donations ?? this.donations,
        donationsReceived: donationsReceived ?? this.donationsReceived,
        playerHouse: playerHouse ?? this.playerHouse,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        tag: json["tag"],
        name: json["name"],
        role: json["role"],
        expLevel: json["expLevel"],
        league: json["league"] == null
            ? null
            : LeagueClass.fromJson(json["league"]),
        trophies: json["trophies"],
        versusTrophies: json["versusTrophies"],
        clanRank: json["clanRank"],
        previousClanRank: json["previousClanRank"],
        donations: json["donations"],
        donationsReceived: json["donationsReceived"],
        playerHouse: json["playerHouse"] == null
            ? null
            : PlayerHouse.fromJson(json["playerHouse"]),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "role": role,
        "expLevel": expLevel,
        "league": league?.toJson(),
        "trophies": trophies,
        "versusTrophies": versusTrophies,
        "clanRank": clanRank,
        "previousClanRank": previousClanRank,
        "donations": donations,
        "donationsReceived": donationsReceived,
        "playerHouse": playerHouse?.toJson(),
      };
}

class LeagueClass {
  LeagueClass({
    this.id,
    this.name,
    this.iconUrls,
  });

  final int? id;
  final String? name;
  final LeagueIconUrls? iconUrls;

  LeagueClass copyWith({
    int? id,
    String? name,
    LeagueIconUrls? iconUrls,
  }) =>
      LeagueClass(
        id: id ?? this.id,
        name: name ?? this.name,
        iconUrls: iconUrls ?? this.iconUrls,
      );

  factory LeagueClass.fromJson(Map<String, dynamic> json) => LeagueClass(
        id: json["id"],
        name: json["name"],
        iconUrls: json["iconUrls"] == null
            ? null
            : LeagueIconUrls.fromJson(json["iconUrls"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls?.toJson(),
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

  factory LeagueIconUrls.fromJson(Map<String, dynamic> json) => LeagueIconUrls(
        small: json["small"],
        tiny: json["tiny"],
        medium: json["medium"],
      );

  Map<String, dynamic> toJson() => {
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

  factory PlayerHouse.fromJson(Map<String, dynamic> json) => PlayerHouse(
        elements: json["elements"] == null
            ? []
            : List<Element>.from(
                json["elements"]!.map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": elements == null
            ? []
            : List<dynamic>.from(elements!.map((x) => x.toJson())),
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

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}
