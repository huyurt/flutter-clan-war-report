// To parse this JSON data, do
//
//     final clanLeagueGroupResponseModel = clanLeagueGroupResponseModelFromMap(jsonString);

import 'dart:convert';

class SearchClansResponseModel {
  final List<SearchClanItem> items;
  final SearchClanPaging paging;

  SearchClansResponseModel({
    required this.items,
    required this.paging,
  });

  SearchClansResponseModel copyWith({
    List<SearchClanItem>? items,
    SearchClanPaging? paging,
  }) =>
      SearchClansResponseModel(
        items: items ?? this.items,
        paging: paging ?? this.paging,
      );

  factory SearchClansResponseModel.fromJson(String str) => SearchClansResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchClansResponseModel.fromMap(Map<String, dynamic> json) => SearchClansResponseModel(
    items: json["items"] == null ? [] : List<SearchClanItem>.from(json["items"]!.map((x) => SearchClanItem.fromMap(x))),
    paging: SearchClanPaging.fromMap(json["paging"]),
  );

  Map<String, dynamic> toMap() => {
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
    "paging": paging.toMap(),
  };
}

class SearchClanItem {
  final String tag;
  final String name;
  final String? type;
  final Location? location;
  final bool? isFamilyFriendly;
  final BadgeUrls? badgeUrls;
  final int? clanLevel;
  final int? clanPoints;
  final int? clanVersusPoints;
  final int? clanCapitalPoints;
  final SearchClanLeague? capitalLeague;
  final int? requiredTrophies;
  final String? warFrequency;
  final int? warWinStreak;
  final int? warWins;
  final int? warTies;
  final int? warLosses;
  final bool? isWarLogPublic;
  final SearchClanLeague? warLeague;
  final int? members;
  final List<Label>? labels;
  final int? requiredVersusTrophies;
  final int? requiredTownhallLevel;
  final ChatLanguage? chatLanguage;

  SearchClanItem({
    required this.tag,
    required this.name,
    this.type,
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
    this.labels,
    this.requiredVersusTrophies,
    this.requiredTownhallLevel,
    this.chatLanguage,
  });

  SearchClanItem copyWith({
    String? tag,
    String? name,
    String? type,
    Location? location,
    bool? isFamilyFriendly,
    BadgeUrls? badgeUrls,
    int? clanLevel,
    int? clanPoints,
    int? clanVersusPoints,
    int? clanCapitalPoints,
    SearchClanLeague? capitalLeague,
    int? requiredTrophies,
    String? warFrequency,
    int? warWinStreak,
    int? warWins,
    int? warTies,
    int? warLosses,
    bool? isWarLogPublic,
    SearchClanLeague? warLeague,
    int? members,
    List<Label>? labels,
    int? requiredVersusTrophies,
    int? requiredTownhallLevel,
    ChatLanguage? chatLanguage,
  }) =>
      SearchClanItem(
        tag: tag ?? this.tag,
        name: name ?? this.name,
        type: type ?? this.type,
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
        labels: labels ?? this.labels,
        requiredVersusTrophies: requiredVersusTrophies ?? this.requiredVersusTrophies,
        requiredTownhallLevel: requiredTownhallLevel ?? this.requiredTownhallLevel,
        chatLanguage: chatLanguage ?? this.chatLanguage,
      );

  factory SearchClanItem.fromJson(String str) => SearchClanItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchClanItem.fromMap(Map<String, dynamic> json) => SearchClanItem(
    tag: json["tag"],
    name: json["name"],
    type: json["type"],
    location: json["location"] == null ? null : Location.fromMap(json["location"]),
    isFamilyFriendly: json["isFamilyFriendly"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromMap(json["badgeUrls"]),
    clanLevel: json["clanLevel"],
    clanPoints: json["clanPoints"],
    clanVersusPoints: json["clanVersusPoints"],
    clanCapitalPoints: json["clanCapitalPoints"],
    capitalLeague: json["capitalLeague"] == null ? null : SearchClanLeague.fromMap(json["capitalLeague"]),
    requiredTrophies: json["requiredTrophies"],
    warFrequency: json["warFrequency"],
    warWinStreak: json["warWinStreak"],
    warWins: json["warWins"],
    warTies: json["warTies"],
    warLosses: json["warLosses"],
    isWarLogPublic: json["isWarLogPublic"],
    warLeague: json["warLeague"] == null ? null : SearchClanLeague.fromMap(json["warLeague"]),
    members: json["members"],
    labels: json["labels"] == null ? [] : List<Label>.from(json["labels"]!.map((x) => Label.fromMap(x))),
    requiredVersusTrophies: json["requiredVersusTrophies"],
    requiredTownhallLevel: json["requiredTownhallLevel"],
    chatLanguage: json["chatLanguage"] == null ? null : ChatLanguage.fromMap(json["chatLanguage"]),
  );

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "name": name,
    "type": type,
    "location": location?.toMap(),
    "isFamilyFriendly": isFamilyFriendly,
    "badgeUrls": badgeUrls?.toMap(),
    "clanLevel": clanLevel,
    "clanPoints": clanPoints,
    "clanVersusPoints": clanVersusPoints,
    "clanCapitalPoints": clanCapitalPoints,
    "capitalLeague": capitalLeague?.toMap(),
    "requiredTrophies": requiredTrophies,
    "warFrequency": warFrequency,
    "warWinStreak": warWinStreak,
    "warWins": warWins,
    "warTies": warTies,
    "warLosses": warLosses,
    "isWarLogPublic": isWarLogPublic,
    "warLeague": warLeague?.toMap(),
    "members": members,
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toMap())),
    "requiredVersusTrophies": requiredVersusTrophies,
    "requiredTownhallLevel": requiredTownhallLevel,
    "chatLanguage": chatLanguage?.toMap(),
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

class SearchClanLeague {
  final int? id;
  final String? name;

  SearchClanLeague({
    this.id,
    this.name,
  });

  SearchClanLeague copyWith({
    int? id,
    String? name,
  }) =>
      SearchClanLeague(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory SearchClanLeague.fromJson(String str) => SearchClanLeague.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchClanLeague.fromMap(Map<String, dynamic> json) => SearchClanLeague(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

class ChatLanguage {
  final int? id;
  final String? name;
  final String? languageCode;

  ChatLanguage({
    this.id,
    this.name,
    this.languageCode,
  });

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

  factory ChatLanguage.fromJson(String str) => ChatLanguage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatLanguage.fromMap(Map<String, dynamic> json) => ChatLanguage(
    id: json["id"],
    name: json["name"],
    languageCode: json["languageCode"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "languageCode": languageCode,
  };
}

class Label {
  final int? id;
  final String? name;
  final IconUrls? iconUrls;

  Label({
    this.id,
    this.name,
    this.iconUrls,
  });

  Label copyWith({
    int? id,
    String? name,
    IconUrls? iconUrls,
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
    iconUrls: json["iconUrls"] == null ? null : IconUrls.fromMap(json["iconUrls"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "iconUrls": iconUrls?.toMap(),
  };
}

class IconUrls {
  final String? small;
  final String? medium;

  IconUrls({
    this.small,
    this.medium,
  });

  IconUrls copyWith({
    String? small,
    String? medium,
  }) =>
      IconUrls(
        small: small ?? this.small,
        medium: medium ?? this.medium,
      );

  factory IconUrls.fromJson(String str) => IconUrls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IconUrls.fromMap(Map<String, dynamic> json) => IconUrls(
    small: json["small"],
    medium: json["medium"],
  );

  Map<String, dynamic> toMap() => {
    "small": small,
    "medium": medium,
  };
}

class Location {
  final int? id;
  final String? name;
  final bool? isCountry;
  final String? countryCode;

  Location({
    this.id,
    this.name,
    this.isCountry,
    this.countryCode,
  });

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

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
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

class SearchClanPaging {
  final Cursors cursors;

  SearchClanPaging({
    required this.cursors,
  });

  SearchClanPaging copyWith({
    Cursors? cursors,
  }) =>
      SearchClanPaging(
        cursors: cursors ?? this.cursors,
      );

  factory SearchClanPaging.fromJson(String str) => SearchClanPaging.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchClanPaging.fromMap(Map<String, dynamic> json) => SearchClanPaging(
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
