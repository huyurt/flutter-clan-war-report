import 'dart:convert';

import '../../utils/enums/war_type_enum.dart';
import 'clan_war_response_model.dart';

class ClanWarAndWarTypeResponseModel {
  ClanWarAndWarTypeResponseModel({
    required this.warType,
    this.warTag,
    required this.clanTag,
    required this.clanWarResponseModel,
  });

  final WarTypeEnum warType;
  final String? warTag;
  final String clanTag;
  final ClanWarResponseModel clanWarResponseModel;

  ClanWarAndWarTypeResponseModel copyWith({
    WarTypeEnum? warType,
    String? warTag,
    String? clanTag,
    ClanWarResponseModel? clanWarResponseModel,
  }) =>
      ClanWarAndWarTypeResponseModel(
        warType: warType ?? this.warType,
        warTag: warTag,
        clanTag: clanTag ?? this.clanTag,
        clanWarResponseModel: clanWarResponseModel ?? this.clanWarResponseModel,
      );

  factory ClanWarAndWarTypeResponseModel.fromJson(String str) =>
      ClanWarAndWarTypeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClanWarAndWarTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      ClanWarAndWarTypeResponseModel(
        warType: json["warType"],
        warTag: json["warTag"],
        clanTag: json["clanTag"],
        clanWarResponseModel:
            ClanWarResponseModel.fromMap(json["clanWarResponseModel"]),
      );

  Map<String, dynamic> toMap() => {
        "warType": warType,
        "warTag": warTag,
        "clanTag": clanTag,
        "clanWarResponseModel": clanWarResponseModel.toMap(),
      };
}
