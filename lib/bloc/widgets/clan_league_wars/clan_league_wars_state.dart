import 'package:equatable/equatable.dart';

import '../../../models/api/clan_league_group_response_model.dart';
import '../../../models/api/clan_war_and_war_type_response_model.dart';

abstract class ClanLeagueWarsState extends Equatable {
  const ClanLeagueWarsState();

  @override
  List<Object?> get props => [];
}

class ClanLeagueWarsStateEmpty extends ClanLeagueWarsState {}

class ClanLeagueWarsStateLoading extends ClanLeagueWarsState {}

class ClanLeagueWarsStateSuccess extends ClanLeagueWarsState {
  const ClanLeagueWarsStateSuccess(
      {required this.clanLeague, required this.clanLeagueWars});

  final ClanLeagueGroupResponseModel clanLeague;
  final List<ClanWarAndWarTypeResponseModel> clanLeagueWars;

  @override
  List<Object?> get props => [clanLeague, clanLeagueWars];

  @override
  String toString() =>
      'ClanLeagueWarsStateSuccess { clanLeague: $clanLeague, clanLeagueWars: $clanLeagueWars }';
}

class ClanLeagueWarsStateError extends ClanLeagueWarsState {
  const ClanLeagueWarsStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
