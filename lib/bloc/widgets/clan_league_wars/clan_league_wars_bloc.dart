import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'clan_league_wars_event.dart';
import 'clan_league_wars_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanLeagueWarsBloc
    extends Bloc<ClanCurrentWarDetailEvent, ClanLeagueWarsState> {
  ClanLeagueWarsBloc() : super(ClanLeagueWarsStateEmpty()) {
    on<GetClanLeagueWars>(_onGetClanCurrentWarDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  Future<void> _onGetClanCurrentWarDetail(
    GetClanLeagueWars event,
    Emitter<ClanLeagueWarsState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(ClanLeagueWarsStateEmpty());
    }

    emit(ClanLeagueWarsStateLoading());

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
        return emit(ClanLeagueWarsStateEmpty());
      }

      return emit(ClanLeagueWarsStateSuccess(
        totalRoundCount: clanLeague.rounds.length,
        clanLeague: clanLeague,
        clanLeagueWars: clanLeagueWars,
      ));
    } catch (error) {
      emit(const ClanLeagueWarsStateError('something went wrong'));
    }
  }
}
