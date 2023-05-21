import '../api/response/clan_detail_response_model.dart';
import '../api/response/clan_league_group_response_model.dart';
import 'clans_current_war_state_model.dart';

class ClanDetailsAndLeagueWarsModel {
  ClanDetailsAndLeagueWarsModel({
    required this.rounds,
    required this.otherClans,
    required this.clanLeague,
    required this.clanLeagueWars,
  });

  final int rounds;
  final List<ClanDetailResponseModel> otherClans;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;

  ClanDetailsAndLeagueWarsModel copyWith({
    int? rounds,
    List<ClanDetailResponseModel>? otherClans,
    ClanLeagueGroupResponseModel? clanLeague,
    List<ClansCurrentWarStateModel>? clanLeagueWars,
  }) =>
      ClanDetailsAndLeagueWarsModel(
        rounds: rounds ?? this.rounds,
        otherClans: otherClans ?? this.otherClans,
        clanLeague: clanLeague ?? this.clanLeague,
        clanLeagueWars: clanLeagueWars ?? this.clanLeagueWars,
      );
}
