import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_league_group_response_model.dart';
import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class ClanLeagueWarsState extends Equatable {
  final BlocStatusEnum status;
  final int totalRoundCount;
  final ClanLeagueGroupResponseModel? clanLeague;
  final List<ClansCurrentWarStateModel> clanLeagueWars;

  const ClanLeagueWarsState._({
    this.status = BlocStatusEnum.loading,
    this.totalRoundCount = 0,
    this.clanLeague,
    this.clanLeagueWars = const <ClansCurrentWarStateModel>[],
  });

  const ClanLeagueWarsState.init() : this._(status: BlocStatusEnum.init);

  const ClanLeagueWarsState.loading() : this._(status: BlocStatusEnum.loading);

  const ClanLeagueWarsState.success(
    totalRoundCount,
    clanLeague,
    clanLeagueWars,
  ) : this._(
            status: BlocStatusEnum.success,
            totalRoundCount: totalRoundCount,
            clanLeague: clanLeague,
            clanLeagueWars: clanLeagueWars);

  const ClanLeagueWarsState.failure() : this._(status: BlocStatusEnum.failure);

  @override
  List<Object?> get props =>
      [status, totalRoundCount, clanLeague, clanLeagueWars];
}
