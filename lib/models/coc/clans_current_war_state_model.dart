import 'dart:convert';

import '../../utils/enums/war_type_enum.dart';
import '../api/response/clan_war_response_model.dart';

class ClansCurrentWarStateModel {
  ClansCurrentWarStateModel({
    required this.warType,
    this.warTag,
    required this.clanTag,
    required this.war,
  });

  final WarTypeEnum warType;
  final String? warTag;
  final String clanTag;
  final ClanWarResponseModel war;

  ClansCurrentWarStateModel copyWith({
    WarTypeEnum? warType,
    String? warTag,
    String? clanTag,
    ClanWarResponseModel? war,
  }) =>
      ClansCurrentWarStateModel(
        warType: warType ?? this.warType,
        warTag: warTag,
        clanTag: clanTag ?? this.clanTag,
        war: war ?? this.war,
      );

  factory ClansCurrentWarStateModel.fromJson(String str) =>
      ClansCurrentWarStateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClansCurrentWarStateModel.fromMap(Map<String, dynamic> json) =>
      ClansCurrentWarStateModel(
        warType: json["warType"],
        warTag: json["warTag"],
        clanTag: json["clanTag"],
        war: ClanWarResponseModel.fromMap(json["war"]),
      );

  Map<String, dynamic> toMap() => {
        "warType": warType,
        "warTag": warTag,
        "clanTag": clanTag,
        "war": war.toMap(),
      };
}
