import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_league_group_response_model.dart';
import '../../../models/coc/clans_current_war_state_model.dart';

abstract class ClanLeagueWarsState extends Equatable {
  const ClanLeagueWarsState();

  @override
  List<Object?> get props => [];
}

class ClanLeagueWarsStateEmpty extends ClanLeagueWarsState {}

class ClanLeagueWarsStateLoading extends ClanLeagueWarsState {}

class ClanLeagueWarsStateSuccess extends ClanLeagueWarsState {
  const ClanLeagueWarsStateSuccess({
    required this.totalRoundCount,
    required this.clanLeague,
    required this.clanLeagueWars,
  });

  final int totalRoundCount;
  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;

  @override
  List<Object?> get props => [totalRoundCount, clanLeague, clanLeagueWars];

  @override
  String toString() =>
      'ClanLeagueWarsStateSuccess { totalRoundCount: $totalRoundCount, clanLeague: $clanLeague, clanLeagueWars: $clanLeagueWars }';
}

class ClanLeagueWarsStateError extends ClanLeagueWarsState {
  const ClanLeagueWarsStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
