import 'package:flutter/material.dart';

class AppConstants {
  static const hivePreferenceKey = 'preferences';
  static const hiveLocaleKey = 'localeKey';
  static const hiveThemeKey = 'themeKey';
  static const hiveClanTagsKey = 'clanTagsKey';
  static const hivePlayerTagsKey = 'playerTagsKey';

  static const envCocBaseUrlKey = 'COC_BASE_URL';
  static const envCocAuthTokenKey = 'COC_AUTH_TOKEN';

  static const englishFlagCode = 'US';

  static const pageSize = 20;

  static const placeholderImage = 'assets/images/placeholder.png';
  static const levelImage = 'level.png';
  static const unknownImage = 'unknown.png';
  static const unknownTroopImage = 'unknown_troop.png';
  static const unrankedImage = '0_unranked.png';
  static const cup1Image = 'cup_1.png';
  static const star0Image = 'star_0.png';
  static const star2Image = 'star_2.png';
  static const star3_0Image = 'star_3_0.png';
  static const star3_1Image = 'star_3_1.png';
  static const star3_2Image = 'star_3_2.png';
  static const star3_3Image = 'star_3_3.png';
  static const arrowDownImage = 'arrow_down.png';
  static const arrowUpImage = 'arrow_up.png';

  static const clashResourceImagePath = 'assets/images/clash-resource/';
  static const clanWarLeaguesImagePath =
      'assets/images/clash-resource/clan-war-leagues/';

  static const heroesImagePath = 'assets/images/clash-resource/home-heroes/';
  static const petsImagePath = 'assets/images/clash-resource/home-pets/';
  static const siegeMachinesImagePath =
      'assets/images/clash-resource/home-siege-machines/';
  static const spellsImagePath = 'assets/images/clash-resource/home-spells/';
  static const troopsImagePath = 'assets/images/clash-resource/home-troops/';

  static const leaguesImagePath = 'assets/images/clash-resource/leagues/';
  static const townHallsImagePath = 'assets/images/clash-resource/town-halls/';

  static const warLeagueUnranked = 48000000;

  static const minMembersFilter = 1.0;
  static const maxMembersFilter = 50.0;
  static const minClanLevelFilter = 1.0;
  static const maxClanLevelFilter = 20.0;

  static const attackerDefaultBackgroundColor = Color.fromARGB(150, 75, 75, 75);
  static const attackerClanBackgroundColor = Color.fromARGB(50, 0, 255, 0);
  static const attackerOpponentBackgroundColor = Color.fromARGB(150, 255, 50, 50);

  static const cocAppClanUrl = 'https://link.clashofclans.com';
  static const cocAppClanProfileUrl = '$cocAppClanUrl?action=OpenClanProfile&tag=';
  static const cocAppPlayerProfileUrl = '$cocAppClanUrl?action=OpenPlayerProfile&tag=';
  static const playStoreUrl = 'https://play.google.com/store/apps/details?id=';
}
