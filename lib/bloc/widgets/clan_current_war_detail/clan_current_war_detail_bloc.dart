import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'clan_current_war_detail_event.dart';
import 'clan_current_war_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanCurrentWarDetailBloc
    extends Bloc<ClanCurrentWarDetailEvent, ClanCurrentWarDetailState> {
  ClanCurrentWarDetailBloc() : super(ClanCurrentWarDetailStateEmpty()) {
    on<GetClanCurrentWarDetail>(_onGetClanCurrentWarDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  Future<void> _onGetClanCurrentWarDetail(
    GetClanCurrentWarDetail event,
    Emitter<ClanCurrentWarDetailState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(ClanCurrentWarDetailStateEmpty());
    }

    emit(ClanCurrentWarDetailStateLoading());

    try {
      ClansCurrentWarStateModel? clanCurrentWar;
      try {
        if (event.warTag.isEmptyOrNull) {
          clanCurrentWar = await CocApiClans.getClanCurrentWar(event.clanTag);
        } else {
          clanCurrentWar = await CocApiClans.getClanLeagueGroupWar(
              event.clanTag, event.warTag!);
        }
      } catch (e) {}

      if (clanCurrentWar == null) {
        emit(ClanCurrentWarDetailStateEmpty());
      } else {
        emit(ClanCurrentWarDetailStateSuccess(
          clanCurrentWarDetail: clanCurrentWar,
        ));
      }
    } catch (error) {
      emit(const ClanCurrentWarDetailStateError('something went wrong'));
    }
  }
}
