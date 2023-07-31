// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromMap(jsonString);

import 'dart:convert';

import 'package:more_useful_clash_of_clans/utils/enums/locale_enum.dart';
import 'package:more_useful_clash_of_clans/utils/enums/theme_enum.dart';

class SettingsModel {
  final int? localeType;
  final int themeType;
  final bool widgetRefresh;

  SettingsModel({
    this.localeType,
    required this.themeType,
    required this.widgetRefresh,
  });

  SettingsModel copyWith({
    int? localeType,
    int? themeType,
    bool? widgetRefresh,
  }) =>
      SettingsModel(
        localeType: localeType ?? this.localeType,
        themeType: themeType ?? this.themeType,
        widgetRefresh: widgetRefresh ?? this.widgetRefresh,
      );

  factory SettingsModel.fromJson(String str) =>
      SettingsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SettingsModel.fromMap(Map<String, dynamic> json) => SettingsModel(
        localeType: json['LocaleType'],
        themeType: json['ThemeType'],
        widgetRefresh: json['WidgetRefresh'],
      );

  Map<String, dynamic> toMap() => {
        'LocaleType': localeType,
        'ThemeType': themeType,
        'WidgetRefresh': widgetRefresh,
      };

  factory SettingsModel.getDefault() => SettingsModel(
        themeType: ThemeEnum.system.index,
        widgetRefresh: false,
      );
}
