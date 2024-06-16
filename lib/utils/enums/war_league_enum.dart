enum WarLeagueEnum {
  unranked(48000000),
  bronzeLeagueIII(48000001),
  bronzeLeagueII(48000002),
  bronzeLeagueI(48000003),
  silverLeagueIII(48000004),
  silverLeagueII(48000005),
  silverLeagueI(48000006),
  goldLeagueIII(48000007),
  goldLeagueII(48000008),
  goldLeagueI(48000009),
  crystalLeagueIII(48000010),
  crystalLeagueII(48000011),
  crystalLeagueI(48000012),
  masterLeagueIII(48000013),
  masterLeagueII(48000014),
  masterLeagueI(48000015),
  championLeagueIII(48000016),
  championLeagueII(48000017),
  championLeagueI(48000018);

  const WarLeagueEnum(this.value);

  final int value;
}
