import '../api/response/clan_league_group_response_model.dart';
import 'clans_current_war_state_model.dart';

class ClanLeagueWarsModel {
  ClanLeagueWarsModel({
    required this.rounds,
    required this.clanLeague,
    required this.clanLeagueWars,
  });

  final int rounds;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;

  ClanLeagueWarsModel copyWith({
    int? rounds,
    ClanLeagueGroupResponseModel? clanLeague,
    List<ClansCurrentWarStateModel>? clanLeagueWars,
  }) =>
      ClanLeagueWarsModel(
        rounds: rounds ?? this.rounds,
        clanLeague: clanLeague ?? this.clanLeague,
        clanLeagueWars: clanLeagueWars ?? this.clanLeagueWars,
      );
}
