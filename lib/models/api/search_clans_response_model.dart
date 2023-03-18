import 'dart:convert';

SearchClansResponseModel searchClanResponseFromJson(String str) => SearchClansResponseModel.fromJson(json.decode(str));

String searchClanResponseToJson(SearchClansResponseModel data) => json.encode(data.toJson());

class SearchClansResponseModel {
  SearchClansResponseModel({
    required this.items,
    required this.paging,
  });

  final List<SearchedClanItem> items;
  final Paging paging;

  factory SearchClansResponseModel.fromJson(Map<String, dynamic> json) => SearchClansResponseModel(
    items: List<SearchedClanItem>.from(json["items"]!.map((x) => SearchedClanItem.fromJson(x))),
    paging: Paging.fromJson(json["paging"]),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "paging": paging.toJson(),
  };
}

class SearchedClanItem {
  SearchedClanItem({
    required this.tag,
    required this.name,
    this.type,
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
    this.location,
    this.chatLanguage,
  });

  final String tag;
  final String name;
  final String? type;
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
  final List<Label>? labels;
  final int? requiredVersusTrophies;
  final int? requiredTownhallLevel;
  final Location? location;
  final ChatLanguage? chatLanguage;

  factory SearchedClanItem.fromJson(Map<String, dynamic> json) => SearchedClanItem(
    tag: json["tag"],
    name: json["name"],
    type: json["type"],
    isFamilyFriendly: json["isFamilyFriendly"],
    badgeUrls: json["badgeUrls"] == null ? null : BadgeUrls.fromJson(json["badgeUrls"]),
    clanLevel: json["clanLevel"],
    clanPoints: json["clanPoints"],
    clanVersusPoints: json["clanVersusPoints"],
    clanCapitalPoints: json["clanCapitalPoints"],
    capitalLeague: json["capitalLeague"] == null ? null : League.fromJson(json["capitalLeague"]),
    requiredTrophies: json["requiredTrophies"],
    warFrequency: json["warFrequency"],
    warWinStreak: json["warWinStreak"],
    warWins: json["warWins"],
    warTies: json["warTies"],
    warLosses: json["warLosses"],
    isWarLogPublic: json["isWarLogPublic"],
    warLeague: json["warLeague"] == null ? null : League.fromJson(json["warLeague"]),
    members: json["members"],
    labels: json["labels"] == null ? [] : List<Label>.from(json["labels"]!.map((x) => Label.fromJson(x))),
    requiredVersusTrophies: json["requiredVersusTrophies"],
    requiredTownhallLevel: json["requiredTownhallLevel"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    chatLanguage: json["chatLanguage"] == null ? null : ChatLanguage.fromJson(json["chatLanguage"]),
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "name": name,
    "type": type,
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
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toJson())),
    "requiredVersusTrophies": requiredVersusTrophies,
    "requiredTownhallLevel": requiredTownhallLevel,
    "location": location?.toJson(),
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

class Label {
  Label({
    this.id,
    this.name,
    this.iconUrls,
  });

  final int? id;
  final String? name;
  final IconUrls? iconUrls;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    id: json["id"],
    name: json["name"],
    iconUrls: json["iconUrls"] == null ? null : IconUrls.fromJson(json["iconUrls"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "iconUrls": iconUrls?.toJson(),
  };
}

class IconUrls {
  IconUrls({
    this.small,
    this.medium,
  });

  final String? small;
  final String? medium;

  factory IconUrls.fromJson(Map<String, dynamic> json) => IconUrls(
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

class Paging {
  Paging({
    required this.cursors,
  });

  final Cursors cursors;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    cursors: Cursors.fromJson(json["cursors"]),
  );

  Map<String, dynamic> toJson() => {
    "cursors": cursors.toJson(),
  };
}

class Cursors {
  Cursors({
    this.after,
    this.before,
  });

  final String? after;
  final String? before;

  factory Cursors.fromJson(Map<String, dynamic> json) => Cursors(
    after: json["after"],
    before: json["before"],
  );

  Map<String, dynamic> toJson() => {
    "after": after,
    "before": before,
  };
}
