import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../services/coc_api/coc_api_clans.dart';
import '../../../utils/constants/locale_key.dart';
import 'clan_league_wars_event.dart';
import 'clan_league_wars_state.dart';

class ClanLeagueWarsBloc
    extends Bloc<ClanCurrentWarDetailEvent, ClanLeagueWarsState> {
  ClanLeagueWarsBloc() : super(const ClanLeagueWarsState.init()) {
    on<GetClanLeagueWars>(_onGetClanCurrentWarDetail,
        transformer: restartable());
  }

  Future<void> _onGetClanCurrentWarDetail(
    GetClanLeagueWars event,
    Emitter<ClanLeagueWarsState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(
          ClanLeagueWarsState.failure(tr(LocaleKey.cocApiErrorMessage)));
    }

    emit(const ClanLeagueWarsState.loading());

    try {
      final clanLeagueWars = <ClansCurrentWarStateModel>[];
      final clanLeague = await CocApiClans.getClanLeagueGroup(event.clanTag);
      final rounds = clanLeague.rounds
          .where((element) =>
              (element.warTags?.isNotEmpty ?? false) &&
              (element.warTags?.any((e2) => e2 != '#0') ?? false))
          .toList();

      final futureGroup = FutureGroup();
      for (final round in rounds) {
        for (String warTag in (round.warTags ?? <String>[])) {
          futureGroup
              .add(CocApiClans.getClanLeagueGroupWar(event.clanTag, warTag));
        }
      }
      futureGroup.close();

      final allResponse = await futureGroup.future;
      for (final response in allResponse) {
        clanLeagueWars.add(response);
      }

      if (clanLeagueWars.isEmpty) {
        return emit(
            ClanLeagueWarsState.failure(tr(LocaleKey.cocApiErrorMessage)));
      }

      return emit(ClanLeagueWarsState.success(
        clanLeague.rounds.length,
        clanLeague,
        clanLeagueWars,
      ));
    } catch (error) {
      if (error is DioError) {
        emit(ClanLeagueWarsState.failure(error.message));
      } else {
        emit(ClanLeagueWarsState.failure(tr(LocaleKey.cocApiErrorMessage)));
      }
    }
  }
}
